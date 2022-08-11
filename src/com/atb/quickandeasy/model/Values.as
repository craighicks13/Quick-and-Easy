package com.atb.quickandeasy.model
{
	public final class Values
	{
		public static var ammortization:int;
		public static var terms:Number;
		public static var interestRate:Number;
		public static var interestManual:Boolean;
		public static var fixedVariable:int;
		public static var paymentFrequency:int;
		public static var loanAmount:Number = 0;
		public static var paymentAmount:Number = 0;
		public static var loanItemList:Vector.<LoanItemVO> = new Vector.<LoanItemVO>();
		
		public static var tradeIn:Number = 0;
		
		public static function get frequencyName():String
		{
			switch(Values.paymentFrequency)
			{
				case 12:
					return 'Monthly';
					break;
				case 4:
					return 'Quarterly';
					break;
				case 2:
					return 'Semi-Annually';
					break;
				case 1:
					return 'Annually';
					break;
			}
			return 'Error';
		}
		
		public static function numberToCurrency(value:Number):String
		{
			if(isNaN(value)) value = 0;
			var currency:String = value.toFixed(2);
			var parts:Array = currency.split('.');
			var cents:String = parts.pop();
			var dollars:String = parts.shift();
			dollars = dollars.replace(/(\d{1,2}?)((\d{3})+)$/, "$1,$2");
			dollars = dollars.replace(/(\d{3})(?=\d)/g, "$1,");
			return '$' + dollars + '.' + cents;
		}
		
		public static function currencyToNumber(value:String):Number
		{
			value = value.substr(1).replace(/,/g, '');
			return Number(value);
		}
	}
}