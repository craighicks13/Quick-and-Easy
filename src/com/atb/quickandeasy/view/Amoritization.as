package com.atb.quickandeasy.view
{
	import com.atb.quickandeasy.interfaces.IInteractiveElement;
	import com.atb.quickandeasy.model.Assets;
	import com.atb.quickandeasy.model.Values;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.ClippedSprite;
	import starling.textures.TextureAtlas;
	
	public class Amoritization extends Sprite implements IInteractiveElement
	{
		private var dial:AmoritizationDial;
		private var overlay:Image;
		private var spinner:ClippedSprite;
		private var cursorPosStage:Point;
		private var boundary:Object = {top:0, bottom:364};
		private var currentY:Number;
		private var lastY:Number;
		private var vx:Number = 0;
		private var isDragging:Boolean = false;
		private var checkpos:Boolean = false;
		private var offset:Number;
		private var tick:int;
		private var cursorPosInitY:Number;
		private var dialInitY:Number;

		private var tween:Tween;
		private var prevDialY:Number = 0;
		public var onChanged:Function;
		public function Amoritization()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var atlas:TextureAtlas = Assets.getTextureAtlas();
			
			dial = new AmoritizationDial();
			
			overlay = new Image(atlas.getTexture('AmoritizationOverlay'));
			overlay.touchable = false;
			addChild(overlay);
			
			spinner = new ClippedSprite();
			addChildAt(spinner, 0);
			
			spinner.addChild(dial);
			spinner.clipRect = new Rectangle(66, 364, overlay.width, overlay.height);
			
			boundary.bottom = -(dial.height - overlay.height);
			
			currentY = dial.y;
			lastY = dial.y;
			
			initToNumber(Values.ammortization || 1);
			
			dial.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(this);
			
			for each (var touch:Touch in touches)
			{
				cursorPosStage = touch.getLocation(stage);
				switch (touch.phase)
				{
					case TouchPhase.BEGAN:
						isDragging = true;
						cursorPosInitY = cursorPosStage.y;
						dialInitY = dial.y;
						checkpos = false;
						if(tween) Starling.juggler.remove(tween);
						break;
					case TouchPhase.MOVED:
						
						break;
					case TouchPhase.ENDED:
						isDragging = false;
						checkpos = true;
						break;
				}
			}
		}
		
		public function update():void
		{
			if(isDragging)
			{
				lastY = currentY;
				currentY = cursorPosStage.y;
				
				dial.y = currentY - cursorPosInitY + dialInitY;
				
				vx = currentY - lastY;
			}	
			else
			{
				dial.y += vx;
			}
			
			if(dial.y <= boundary.bottom)
			{
				dial.y  = boundary.bottom;
				// vx *= -1;
				vx *= -0.15;
			}
			else if(dial.y >= boundary.top)
			{
				dial.y = boundary.top;
				// vx *= -1;
				vx *= -0.15;
			}
			
			vx *= 0.85;
			if(Math.abs(vx) < 0.5)
			{
				vx = 0;
				if(checkpos) moveToNumber(this.currentNumber);
			}
			else if(Math.abs(Math.abs(dial.y) - Math.abs(prevDialY)) > 20)
			{
				prevDialY = dial.y;
				Assets.amortizationSound.play();
			}
		}
		
		public function moveToNumber(value:int):void
		{
			checkpos = false;
			
			if(tween)
				tween.reset(dial, .5, Transitions.EASE_OUT_ELASTIC);
			else
				tween = new Tween(dial, .5, Transitions.EASE_OUT_ELASTIC);
			
			tween.animate("y", (-(value) * 50) + 25);
			Starling.juggler.add(tween);
			Assets.amortizationLockSound.play();
			if(onChanged != null) onChanged();
		}
		
		private function initToNumber(value:int):void
		{
			dial.y = (-(value) * 50) + 25;
		}
		
		public function get currentNumber():int
		{
			return Math.round(Math.abs(dial.y - 25) / 50);
		}
		
		public function destroy():void
		{
			removeChildren();
			
			dial.destroy();
			dial = null;
			
			overlay.dispose();
			overlay = null;
			
			spinner.dispose();
			spinner = null;
		}
	}
}