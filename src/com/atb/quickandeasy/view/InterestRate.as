package com.atb.quickandeasy.view
{
	import com.atb.quickandeasy.interfaces.IInteractiveElement;
	import com.atb.quickandeasy.model.Assets;
	import com.atb.quickandeasy.model.Values;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.engine.FontWeight;
	
	import flashx.textLayout.formats.TextAlign;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	
	public class InterestRate extends Sprite implements IInteractiveElement
	{
		public static const VARIABLE_UNDER_25K:Number = 5;
		public static const VARIABLE_OVER_25K:Number = 4;
		
		public static const FIXED_UNDER_25K_1YEAR:Number = 4.9;
		public static const FIXED_UNDER_25K_2YEAR:Number = 4.95;
		public static const FIXED_UNDER_25K_3YEAR:Number = 5;
		public static const FIXED_UNDER_25K_4YEAR:Number = 5.1;
		public static const FIXED_UNDER_25K_5YEAR:Number = 5.25;
		
		public static const FIXED_OVER_25K_1YEAR:Number = 4.4;
		public static const FIXED_OVER_25K_2YEAR:Number = 4.45;
		public static const FIXED_OVER_25K_3YEAR:Number = 4.5;
		public static const FIXED_OVER_25K_4YEAR:Number = 4.6;
		public static const FIXED_OVER_25K_5YEAR:Number = 4.1;
		
		protected static const MAX_ROTATION:Number = 243;
		
		private var needle:Image;
		private var ratebox:Button;
		private var interest:starling.text.TextField;

		private var tween:Tween;
		private var _amount:flash.text.TextField;
		private var manual:Boolean = Values.interestManual || false;
		
		public function InterestRate()
		{
			addEventListener(starling.events.Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:starling.events.Event):void
		{
			removeEventListener(starling.events.Event.ADDED_TO_STAGE, init);
			
			var atlas:TextureAtlas = Assets.getTextureAtlas();
			
			ratebox = new Button(atlas.getTexture('InterestRateNumberBox'), '', atlas.getTexture('InterestRateNumberBoxOver'));
			ratebox.addEventListener(starling.events.Event.TRIGGERED, onSetInterestRate);
			ratebox.alphaWhenDisabled = 1;
			ratebox.pivotX = ratebox.width * -.5;
			ratebox.pivotY = ratebox.height * -.5;
			ratebox.x = -75;
			ratebox.y = 1;
			addChild(ratebox);
			
			needle = new Image(atlas.getTexture('InterestRateNeedle'));
			needle.touchable = false;
			needle.pivotX = 73;
			needle.pivotY = 15;
			addChild(needle);
						
			interest = new starling.text.TextField(65, 25, "00.00", "ModeSeven", 20, Color.WHITE);
			interest.touchable = false;
			interest.x = -16;
			interest.y = 29;
			addChild(interest);
		}
		
		protected function onFocusOut(event:FocusEvent):void
		{
			_amount.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_amount.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			if(_amount.text != "")
			{
				var num:Number = Number(_amount.text);
				if(!isNaN(num))
				{
					if(num > 12)
					{
						num = 12;
						// Cutting corners by hardcoding Application path
						Application(this.parent.parent).showMessage('Interest Rate', 'Interest rate cannot exceed 12%');
					}
					this.setRateManual(num);
					manual = true;
				}
			}
			Starling.current.nativeOverlay.removeChild(_amount);
			_amount = null;
			
			interest.visible = true;
			ratebox.enabled = true;
		}
		
		protected function onAmountInit(event:flash.events.Event):void
		{
			Starling.current.nativeStage.focus = _amount;		
			interest.visible = false;
		}
		
		private function onSetInterestRate(event:starling.events.Event):void
		{
			ratebox.enabled = false;
			
			var format:TextFormat = new TextFormat();
			format.font = 'Arial';
			format.color = 0xFFFFFF;
			format.size = 19 * Assets.scale;
			format.align = TextAlign.LEFT;
			format.bold = true;
			
			_amount = new flash.text.TextField();
			_amount.type = TextFieldType.INPUT;
			_amount.addEventListener(flash.events.Event.ADDED_TO_STAGE, onAmountInit, false, 0, true);
			_amount.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true);
			_amount.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			_amount.restrict = "0-9.";
			_amount.height = 25 * Assets.scale;
			_amount.width = 65 * Assets.scale;
			_amount.x = (this.x - 31) * Assets.scale;
			_amount.y = (this.y + 29) * Assets.scale;
			_amount.defaultTextFormat = format;
			_amount.text = interest.text;
			Starling.current.nativeOverlay.addChild(_amount);
		}
		
		private function onKeyPressed(event:KeyboardEvent):void
		{
			if(event.keyCode == 13)
			{
				Starling.current.nativeStage.focus = null;
			}
		}
		
		protected function toRadians(value:Number):Number
		{
			return value * Math.PI / 180;
		}
		
		protected function toDegrees(value:Number):Number
		{
			//value = value < 0 ? Math.abs(value) + Math.PI : value;
			return value * 180 / Math.PI;
		}
		
		protected function setValueFromRotation():void
		{
			interest.text = (toDegrees(needle.rotation)/MAX_ROTATION * 12).toFixed(2);
		}
		
		private function animateNeedle(value:Number):void
		{
			tween = new Tween(needle, 1, Transitions.EASE_OUT_ELASTIC);
			tween.animate("rotation", toRadians(MAX_ROTATION * (value/12)));
			//tween.onUpdate = setValueFromRotation;
			Starling.juggler.add(tween); 
		}
		
		public function setRateManual(value:Number):void
		{
			interest.text = value.toFixed(2);
			animateNeedle(value);
		}
		
		public function set rate(value:Number):void
		{
			if(manual) return;
			interest.text = value.toFixed(2).toString();
			animateNeedle(value);
		}
		
		public function get rate():Number
		{
			return Number(interest.text);
		}
		
		public function set isManual(value:Boolean):void
		{
			manual = value;
		}
		
		public function get isManual():Boolean
		{
			return manual;
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			removeChildren(0, -1, true);
			needle = null;
			interest = null;
			ratebox = null;
		}
	}
}