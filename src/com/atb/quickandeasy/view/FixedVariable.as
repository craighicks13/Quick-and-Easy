package com.atb.quickandeasy.view
{
	import com.atb.quickandeasy.interfaces.IInteractiveElement;
	import com.atb.quickandeasy.model.Assets;
	import com.atb.quickandeasy.model.Values;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.TextureAtlas;
	
	public class FixedVariable extends Sprite implements IInteractiveElement
	{
		public static const FIXED:int = 1;
		public static const VARIABLE:int = 2;
		
		public static var CURRENT:int;
		
		private var atlas:TextureAtlas;
		private var _fixed:Button;
		private var _variable:Button;
		
		public var onChanged:Function;
		
		public function FixedVariable()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			atlas = Assets.getTextureAtlas();
			
			_fixed = new Button(atlas.getTexture('Fixed'));
			_fixed.scaleWhenDown = 1;
			_fixed.addEventListener(Event.TRIGGERED, onFixedHit);
			addChild(_fixed);
			
			_variable = new Button(atlas.getTexture('Variable'));
			_variable.scaleWhenDown = 1;
			_variable.addEventListener(Event.TRIGGERED, onVariableHit);
			_variable.y = _fixed.height + 1;
			addChild(_variable);
			
			setRate(Values.fixedVariable || FIXED);
		}
		
		public static function get currentName():String
		{
			return Values.fixedVariable == FixedVariable.FIXED ? 'Fixed' : 'Variable';
		}
		
		protected function onFixedHit(event:Event):void
		{
			if(CURRENT == VARIABLE)
			{
				Assets.fixedSound.play();
				setRate(FIXED);
			}
		}
		
		protected function onVariableHit(event:Event):void
		{
			if(CURRENT == FIXED)
			{
				Assets.fixedSound.play();
				setRate(VARIABLE);
			}
		}
		
		public function setRate(value:int):void
		{
			CURRENT = value;
			if(CURRENT == VARIABLE)
			{
				_variable.upState = atlas.getTexture('VariableOn');
				_fixed.upState = atlas.getTexture('Fixed');
			}
			else
			{
				_variable.upState = atlas.getTexture('Variable');
				_fixed.upState = atlas.getTexture('FixedOn');
			}
			
			if(onChanged != null) onChanged();
		}
		
		public function update():void
		{
		}
		
		public function destroy():void
		{
		}
	}
}