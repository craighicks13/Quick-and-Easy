package com.atb.quickandeasy.view
{
	import com.atb.quickandeasy.interfaces.IInteractiveElement;
	import com.atb.quickandeasy.model.Values;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	
	public class PaymentTotal extends Sprite implements IInteractiveElement
	{
		private var payment:TextField;
		public function PaymentTotal()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			payment = new TextField(350, 45, "$10.00", "ModeSeven", 35, Color.WHITE);
			payment.autoScale = true;
			payment.hAlign = "right";
			addChild(payment);
		}
		
		public function set total(value:Number):void
		{
			payment.text = Values.numberToCurrency(value);
		}
		
		public function get total():Number
		{
			return Values.currencyToNumber(payment.text);
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			payment.dispose();
			payment = null;
		}
	}
}