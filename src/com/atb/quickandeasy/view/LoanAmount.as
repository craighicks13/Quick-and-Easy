package com.atb.quickandeasy.view
{
	import com.atb.quickandeasy.interfaces.IInteractiveElement;
	import com.atb.quickandeasy.model.Assets;
	import com.atb.quickandeasy.model.LoanItemVO;
	import com.atb.quickandeasy.model.Values;
	
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
	
	public class LoanAmount extends Sprite implements IInteractiveElement
	{
		private static const DEFAULT_TEXT:String = '';
		private var _amount:TextField;
		private var hasFocus:Boolean = false;
		
		public var isTotalField:Boolean = false;
		public var onChanged:Function;
		
		public function LoanAmount()
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
			format.align = TextAlign.RIGHT;
			
			_amount = new TextField();
			_amount.type = TextFieldType.INPUT;
			_amount.restrict = "0-9.";
			_amount.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_amount.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_amount.height = 30 * Assets.scale;
			_amount.width = 310 * Assets.scale;
			_amount.x = 353 * Assets.scale;
			_amount.y = 240 * Assets.scale;
			_amount.defaultTextFormat = format;
			_amount.text = DEFAULT_TEXT;
			Starling.current.nativeOverlay.addChild(_amount);
		}
		
		protected function onFocusIn(event:FocusEvent):void
		{
			hasFocus = true;
			_amount.text = amount.toString();
			_amount.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			if(_amount.text == DEFAULT_TEXT || _amount.text == "0")
			{
				_amount.text = "";
			}
			else if(isTotalField && Values.loanItemList.length)
			{
				// Cutting corners by hardcoding Application path
				Application(this.parent.parent).showMessage('Loan Amount', 'Changes to the loan amount will delete existing multiple equipment entries.');
			}
			
			Assets.enterLoanSound.play();
		}
		
		protected function onFocusOut(event:FocusEvent):void
		{
			hasFocus = false;
			_amount.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			
			amount = (_amount.text == '') ? 0: Number(_amount.text);
			
			if(Application.CURRENT_STATE == Application.DASHBOARD && Values.loanAmount && Values.loanAmount != this.amount)
			{
				Values.tradeIn = 0;
				Values.loanItemList = new Vector.<LoanItemVO>();
			}
			
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
			_amount.width = w * Assets.scale;
		}
		
		public function updatePosition(xpos:Number, ypos:Number):void
		{
			_amount.x = xpos * Assets.scale;
			_amount.y = ypos * Assets.scale;
		}
		
		public function set amount(value:Number):void
		{
			_amount.text = value == 0 ? DEFAULT_TEXT : Values.numberToCurrency(value);
		}
		
		public function get amount():Number
		{
			return _amount.text == DEFAULT_TEXT ? 0 : _amount.text.charAt(0) == '$' ? Values.currencyToNumber(_amount.text) : Number(_amount.text);
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			_amount.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_amount.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			Starling.current.nativeOverlay.removeChild(_amount);
			_amount = null;
		}
	}
}