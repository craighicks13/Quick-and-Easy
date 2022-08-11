package com.atb.quickandeasy.view
{
	import com.atb.quickandeasy.interfaces.IApplicationState;
	import com.atb.quickandeasy.model.Assets;
	import com.atb.quickandeasy.model.Values;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	
	public class DashBoard extends Sprite implements IApplicationState
	{
		public static const NAME:String = 'DashBoard';
		
		private var payment_amount:Number = 48192706.53;
		private var bg:Image;

		private var dial:TermsDial;
		private var dialNumbers:TermsDialNumbers;

		private var payment:PaymentTotal;
		private var amount:LoanAmount;
		private var interestRate:InterestRate;
		private var options:PaymentOptions;
		private var term:FixedVariable;
		private var loans:Button;
		private var send:Button;

		private var amoritization:Amoritization;

		private var _interest_rate:Number;
		private var ready:Boolean = false;
		
		private var app:Application;
		
		public function DashBoard(value:Application)
		{
			app = value;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			bg = new Image(Assets.getTexture('DashBackground'));
			bg.blendMode = BlendMode.NONE;
			bg.touchable = false;
			addChild(bg);
			
			var atlas:TextureAtlas = Assets.getTextureAtlas();
			
			amoritization = new Amoritization();
			amoritization.x = 66;
			amoritization.y = 364;
			addChild(amoritization);
			
			payment = new PaymentTotal();
			payment.x = 345;
			payment.y = 644;
			addChild(payment);
			
			loans = new Button(atlas.getTexture('MultipleLoanAmountsButton'));
			loans.addEventListener(Event.TRIGGERED, onLoansButton);
			loans.scaleWhenDown = .97;
			loans.x = 745;
			loans.y = 235;
			addChild(loans);
			
			send = new Button(atlas.getTexture('SendButton'));
			send.addEventListener(Event.TRIGGERED, onSendButton);
			send.scaleWhenDown = .97;
			send.x = 759;
			send.y = 617;
			addChild(send);
			
			term = new FixedVariable();
			term.x = 695;
			term.y = 366;
			addChild(term);
			
			options = new PaymentOptions();
			options.x = 810;
			options.y = 361;
			addChild(options);
			
			amount = new LoanAmount();
			amount.isTotalField = true;
			addChild(amount);
			
			dial = new TermsDial();
			dial.x = 399;
			dial.y = 538;
			addChild(dial);
			
			dialNumbers = new TermsDialNumbers();
			dialNumbers.x = 322;
			dialNumbers.y = 461;
			addChild(dialNumbers);
			
			interestRate = new InterestRate();
			interestRate.x = 556;
			interestRate.y = 457;
			addChild(interestRate);
			
			onSetConnections();
		}
		
		private function onSetConnections():void
		{
			interestRate.setRateManual(Values.interestRate || 1);
			amount.amount = Values.loanAmount || 0;
			
			//amoritization.onChanged = updateInterest;
			amount.onChanged = updateInterest;
			term.onChanged = updateInterest;
			dialNumbers.onChange = updateInterest;
			//options.onChanged = updateInterest;
			updateInterest();
		}
		
		private function onLoansButton(event:Event):void
		{
			app.state = Application.MULTIPLE_LOANS;
		}
		
		private function onSendButton(event:Event):void
		{
			Assets.submitSound.play();
			app.state = Application.APPROVAL_SCREEN;
		}
		
		public function updateInterest():void
		{
			interestRate.rate = InterestRate[(FixedVariable.CURRENT == FixedVariable.FIXED ? "FIXED" : "VARIABLE") + (amount.amount < 25000 ? '_UNDER_25K' : '_OVER_25K') + (FixedVariable.CURRENT == FixedVariable.VARIABLE ? '' : dialNumbers.set_number < 5 ? '_' + dialNumbers.set_number.toString() + 'YEAR' : '_5YEAR')];
		}
		
		public function update():void
		{
			dial.update();
			dialNumbers.set_number = Math.round(dial.value);
			dialNumbers.update();
			amoritization.update();
			
			/**
			 * Ammortization:		amoritization.currentNumber
			 * Term of Loan:		dial.value (precise value between 1-10) or dialNumbers.cost (cost per report)
			 * Interest Rate:		interestRate.rate
			 * Loan Amount:			amount.amount
			 * Payment Frequency:	options.annualFrequency
			 * Fixed Variable:		FixedVariable.CURRENT
			 * */
			
			_interest_rate = ((interestRate.rate/100) / options.annualFrequency);
			payment.total = _interest_rate * amount.amount / (1 - Math.pow((1 + _interest_rate), -(amoritization.currentNumber * options.annualFrequency))); 
		}
		
		public function destroy():void
		{
			Values.ammortization = amoritization.currentNumber;
			Values.terms = dial.value;
			Values.interestRate = interestRate.rate;
			Values.interestManual = interestRate.isManual;
			Values.fixedVariable = FixedVariable.CURRENT;
			Values.paymentFrequency = options.annualFrequency;
			Values.loanAmount = amount.amount;
			Values.paymentAmount = payment.total;
			
			removeChildren();
			
			amount.destroy();
			amount = null;
			
			loans.dispose();
			loans = null;
			
			send.dispose();
			send = null;
			
			term.destroy();
			term = null;
			
			payment.dispose();
			payment = null;
			
			options.destroy();
			options = null;
			
			dial.destroy();
			dial = null;
			
			dialNumbers.destroy();
			dialNumbers = null;
			
			interestRate.destroy();
			interestRate = null;
			
			bg.dispose();
			bg = null;
		}
	}
}