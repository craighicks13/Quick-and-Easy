package com.atb.quickandeasy.view
{
	import com.atb.quickandeasy.interfaces.IInteractiveElement;
	import com.atb.quickandeasy.model.Assets;
	import com.atb.quickandeasy.model.Values;
	
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;
	
	public class PaymentOptions extends Sprite implements IInteractiveElement
	{
		private var current_number:Number = 12;
		private var set_number:Number = 12;
		private var thumb:Image;
		private var cursorPosStage:Point;
		private var num:Image;
		
		public var onChanged:Function;

		private var atlas:TextureAtlas;
		
		public function PaymentOptions()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			atlas = Assets.getTextureAtlas();
			thumb = new Image(atlas.getTexture('PaymentOptionsThumb'));
			addChild(thumb);
			
			annualFrequency = Values.paymentFrequency || 12;
			
			thumb.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(this);
			
			for each (var touch:Touch in touches)
			{
				cursorPosStage = touch.getLocation(this);
				
				switch (touch.phase)
				{
					case TouchPhase.BEGAN:
						
						break;
					case TouchPhase.MOVED:
						checkThumbPos();
						break;
					case TouchPhase.ENDED:
						snapThumb();
						break;
				}
			}
		}
		
		protected function snapThumb():void
		{
			if(thumb.y < 28)
			{
				thumb.y = 0;
			}
			else if(thumb.y < 82)
			{
				thumb.y = 55;
			}
			else if(thumb.y < 137)
			{
				thumb.y = 110;
			}
			else
			{
				thumb.y = 164;
			}
			checkNumber();
			if(onChanged != null) onChanged();
		}
		
		protected function checkNumber():void
		{
			
			if(thumb.y < 28)
			{
				set_number = 12;
			}
			else if(thumb.y < 82)
			{
				set_number = 4;
			}
			else if(thumb.y < 137)
			{
				set_number = 2;
			}
			else
			{
				set_number = 1;
			}
			setNumber();
		}
		
		private function setNumber():void
		{
			if(num)
			{
				removeChild(num);
				num.dispose();
			}
			num = new Image(atlas.getTexture('PaymentOption' + set_number));
			addChild(num);
			
			switch(set_number)
			{
				case 1:
					num.x = 54;
					num.y = 164;
					break;
				case 2:
					num.x = 54;
					num.y = 110;
					break;
				case 4:
					num.x = 54;
					num.y = 55;					
					break;
				case 12:
					num.x = 53;
					num.y = 0;
					break;
			}
			
			
			if(current_number != set_number) 
			{
				//Assets.frequencySound.play();
				Assets.amortizationLockSound.play();
			}
			current_number = set_number;
		}
		
		protected function checkThumbPos():void
		{
			if(cursorPosStage.y < 0)
			{
				thumb.y = 0;
			}
			else if(cursorPosStage.y > 164)
			{
				thumb.y = 164;
			}
			else
			{
				thumb.y = cursorPosStage.y;
			}
			checkNumber();
		}
		
		public function set annualFrequency(value:int):void
		{
			switch(value)
			{
				case 1:
					thumb.y = 164;
					set_number = value;
					break;
				case 2:
					thumb.y = 110;
					set_number = value;
					break;
				case 4:
					thumb.y = 55;
					set_number = value;
					break;
				case 12:
					thumb.y = 0;
					set_number = value;
					break;
			}
			setNumber();
		}
		
		public function get annualFrequency():int
		{
			return current_number;
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			
		}
	}
}