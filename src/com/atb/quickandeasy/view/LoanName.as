package com.atb.quickandeasy.view
{
	import com.atb.quickandeasy.interfaces.IInteractiveElement;
	import com.atb.quickandeasy.model.Assets;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class LoanName extends Sprite implements IInteractiveElement
	{
		private static const DEFAULT_TEXT:String = '';
		private var _name:TextField;
		
		public var onChanged:Function;
		
		public function LoanName()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var format:TextFormat = new TextFormat();
			format.font = 'Arial';
			format.color = 0x656565;
			format.size = 24 * Assets.scale;
			format.align = TextAlign.LEFT;
			
			_name = new TextField();
			_name.type = TextFieldType.INPUT;
			_name.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_name.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_name.width = 310 * Assets.scale;
			_name.height = 30 * Assets.scale;
			_name.x = 353 * Assets.scale;
			_name.y = 240 * Assets.scale;
			_name.defaultTextFormat = format;
			_name.text = DEFAULT_TEXT;
			Starling.current.nativeOverlay.addChild(_name);
		}
		
		protected function onFocusIn(event:FocusEvent):void
		{
			if(_name.text == DEFAULT_TEXT) _name.text = "";
			_name.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			Assets.enterLoanSound.play();
		}
		
		protected function onFocusOut(event:FocusEvent):void
		{
			if(_name.text == '') _name.text = DEFAULT_TEXT;
			_name.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			if(onChanged != null) onChanged();
		}
		
		private function onKeyPressed(event:KeyboardEvent):void
		{
			if(event.keyCode == 13)
			{
				Starling.current.nativeStage.focus = null;
			}
		}
		
		public function updateWidth(w:Number):void
		{
			_name.width = w * Assets.scale;
		}
		
		public function updatePosition(xpos:Number, ypos:Number):void
		{
			_name.x = xpos * Assets.scale;
			_name.y = ypos * Assets.scale;
		}
		
		public function set text(value:String):void
		{
			_name.text = value == '' ? DEFAULT_TEXT : value;
		}
		
		public function get text():String
		{
			return _name.text == DEFAULT_TEXT ? '' : _name.text;
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			_name.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_name.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			
			Starling.current.nativeOverlay.removeChild(_name);
			_name = null;
		}
	}
}