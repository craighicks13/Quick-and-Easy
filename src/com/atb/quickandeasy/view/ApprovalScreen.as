package com.atb.quickandeasy.view
{
	import com.atb.quickandeasy.interfaces.IApplicationState;
	import com.atb.quickandeasy.model.Assets;
	import com.atb.quickandeasy.model.SubmitData;
	import com.atb.quickandeasy.model.Values;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	public class ApprovalScreen extends Sprite implements IApplicationState
	{
		public static const NAME:String = 'ApprovalScreen';
		public var onBackToDash:Function;
		
		private var bg:Image;
		private var back:Button;
		private var app:Application;
		private var _email:Button;
		private var _ready:Button;
		private var _submitting:Image;
		//private var emailMessage:MailExtension;

		private var sd:SubmitData;

		private var atlas:TextureAtlas;
		private var _spinner:Image;
		
		public function ApprovalScreen(value:Application)
		{
			app = value;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			bg = new Image(Assets.getTexture('ApprovalBackground'));
			addChild(bg);
			
			atlas = Assets.getTextureAtlas();
			
			back = new Button(atlas.getTexture('BackButton'));
			back.addEventListener(Event.TRIGGERED, onBackButton);
			back.scaleWhenDown = .97;
			back.x = 15;
			back.y = 15;
			addChild(back);
			
			_email = new Button(atlas.getTexture('EmailQuote'));
			_email.addEventListener(Event.TRIGGERED, onReadyTriggered);
			_email.scaleWhenDown = .97;
			_email.x = 266;
			_email.y = 310;
			addChild(_email);
			
			_ready = new Button(atlas.getTexture('ReadyToBuy'), '', atlas.getTexture('ReadyToBuyOver'));
			_ready.addEventListener(Event.TRIGGERED, onReadyTriggered);
			_ready.x = 604;
			_ready.y = 310;
			addChild(_ready);
			
			/*
			_email.enabled = false;
			_ready.enabled = false;
			app.showMessage('Network Error', 'No network connection detected. Please connect to the internet to submit information.');
			*/
		}
		
		private function onReadyTriggered(event:Event):void
		{
			_email.enabled = false;
			_ready.enabled = false;
			
			_submitting = new Image(atlas.getTexture('SubmittingData'));
			_submitting.x = 512 - _submitting.width * .5;
			_submitting.y = 200;
			addChild(_submitting);
			
			_spinner = new Image(atlas.getTexture('Spinner'));
			_spinner.pivotX = _spinner.width * .5;
			_spinner.pivotY = _spinner.height * .5;
			_spinner.x = 512;
			_spinner.y = _submitting.y + 37;
			addChild(_spinner);
			
			sd = new SubmitData();
			sd.onSendError = onSendError;
			sd.onSendSuccess = onSendSuccess;
			sd.sendData(xmlContentBody);
			//app.openWebView();
		}
		
		private function onSendSuccess():void
		{
			cleanLoading();
		}
		
		private function onSendError(title:String = '', value:String = ''):void
		{
			cleanLoading();
			app.showMessage(title, value);
		}
		
		private function cleanLoading():void
		{
			removeChild(_submitting);
			_submitting.dispose();
			_submitting = null;
			
			removeChild(_spinner);
			_spinner.dispose();
			_spinner = null;
			
			_email.enabled = true;
			_ready.enabled = true;
		}
		
		private function get xmlContentBody():XML
		{			
			var xml:XML = 	<Root>
								<Application>
									<LoanAmount>{Values.loanAmount.toFixed(2)}</LoanAmount>
									<TradeInAndCash>{Values.tradeIn.toFixed(2)}</TradeInAndCash>
									<Ammortization>{Values.ammortization}</Ammortization>
									<TermOfLoan>{Math.round(Values.terms)}</TermOfLoan>
									<InterestRate>{Values.interestRate}</InterestRate>
									<InterestRateType>{FixedVariable.currentName}</InterestRateType>
									<Payment>{Values.paymentAmount.toFixed(2)}</Payment>
									<PaymentFrequency>{Values.frequencyName}</PaymentFrequency>
									<DealerName/>
									<SalesPersonName/>
									<SalesPersonEmail/>
									<SalesPersonComments/>
									<BuyerName/>
									<BuyerEmail/>
									<BuyerComments/>
								</Application>
								<EquipmentDetails/>
							</Root>;
			
				for(var i:int = 0; i < Values.loanItemList.length; i++)
				{
					var newnode:XML = new XML();  
					newnode = 
						<EquipmentDetail> 
							<Name>{Values.loanItemList[i].name}</Name>
							<Amount>{Values.loanItemList[i].cost.toFixed(2)}</Amount>
							<DateCreated>1974-11-16T12:00:00</DateCreated>
							<DateLastModified>1974-11-16T12:00:00</DateLastModified>
						</EquipmentDetail>; 
					
					xml.EquipmentDetails[0].appendChild(newnode);
				}
				
				
										

			
			return xml;
		}
		/*
		private function onEmailTriggered(event:Event):void
		{
			emailMessage = new MailExtension();
			emailMessage.addEventListener(MailExtensionEvent.MAIL_COMPOSER_EVENT, onMailEvent);
			emailMessage.sendMail('ATB Quick & Easy Submission', this.emailContentBody, 'craighicks13@gmail.com');
		}
		*/
		private function get emailContentBody():String
		{
			var txt:String = '';
			txt += '<html><body><p>Loan Info:</br><ul>';
			txt += '<li>Loan Amount: <b>$' + Values.loanAmount.toFixed(2) + '</b></li>';
			
			if(Values.loanItemList.length)
			{
				txt += '<ul>';
				
				for(var i:int = 0; i < Values.loanItemList.length; i++)
				{
					txt += '<li>' + Values.loanItemList[i].name + ': $' + Values.loanItemList[i].cost.toFixed(2) + '</li>';
				}
				
				txt += '</ul>';
			}
			
			txt += '<li>Trade In Amount: <b>$' + Values.tradeIn.toFixed(2) + '</b></li>';
			txt += '<li>Ammortization: <b>' + Values.ammortization.toString() + '</b></li>';
			txt += '<li>Terms of Loan: <b>' + Math.round(Values.terms).toString() + '</b></li>';
			txt += '<li>Interest Rate: <b>' + Values.interestRate.toString() + '</b></li>';
			txt += '<li>Fixed/Variable: <b>' + FixedVariable.currentName + '</b></li>';
			txt += '<li>Payment Frequency: <b>' + Values.paymentFrequency.toString() + '</b></li>';
			txt += '<li>Payment Total: <b>$' + Values.paymentAmount.toString() + '</b></li>';
			txt += '</ul>';
			txt += '</p></br></br>';
			txt += 'Have a nice day.';
			txt += '</body>';
			txt += '</html>';
			return txt;
		}
		/*
		protected function onMailEvent(event:MailExtensionEvent):void
		{
			//trace(event.composeResult);
			
			switch(event.composeResult)
			{
				case 'MAIL_CANCELED':
				case 'MAIL_SENT':
				case 'MAIL_SAVED':
					emailMessage.removeEventListener(MailExtensionEvent.MAIL_COMPOSER_EVENT, onMailEvent);
					emailMessage = null;
					break;
			}
			
			
		}
		*/
		private function onBackButton(event:Event):void
		{
			app.state = Application.DASHBOARD;
		}
		
		public function update():void
		{
			if(_spinner) _spinner.rotation += .15;
		}
		
		public function destroy():void
		{
			back.removeEventListener(Event.TRIGGERED, onBackButton);
			removeChild(back);
			back.dispose();
			back = null;
			
			removeChild(bg);
			bg.dispose();
			bg = null;
			
			_email.removeEventListener(Event.TRIGGERED, onReadyTriggered);
			removeChild(_email);
			_email.dispose();
			_email = null;
			
			_ready.removeEventListener(Event.TRIGGERED, onReadyTriggered);
			removeChild(_ready);
			_ready.dispose();
			_ready = null;
			
			removeChildren(0, -1, true);
		}
	}
}