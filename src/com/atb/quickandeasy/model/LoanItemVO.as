package com.atb.quickandeasy.model
{
	public class LoanItemVO
	{
		public var name:String;
		public var cost:Number;
		
		public function LoanItemVO(name:String = undefined, cost:Number = undefined):void
		{
			this.name = name;
			this.cost = cost;
		}
	}
}