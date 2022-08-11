package com.atb.quickandeasy.view
{
	import com.atb.quickandeasy.interfaces.IApplicationState;
	import com.atb.quickandeasy.model.Assets;
	import com.atb.quickandeasy.model.LoanItemVO;
	import com.atb.quickandeasy.model.Values;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	public class MultipleLoans extends Sprite implements IApplicationState
	{
		public static const NAME:String = 'MultipleLoans';
		public var onBackToDash:Function;
		
		private var bg:Image;
		private var back:Button;
		private var app:Application;
		private var tradeIn:LoanAmount;
		private var submit:Button;
		private var add:Button;
		private var loanItem:LoanItem;
		private var itemList:Vector.<LoanItem> = new Vector.<LoanItem>();;
		
		public function MultipleLoans(value:Application)
		{
			app = value;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			bg = new Image(Assets.getTexture('AdditionalBackground'));
			bg.blendMode = BlendMode.NONE;
			bg.touchable = false;
			addChild(bg);
			
			var atlas:TextureAtlas = Assets.getTextureAtlas();
			
			back = new Button(atlas.getTexture('BackButton'));
			back.addEventListener(Event.TRIGGERED, onBackButton);
			back.scaleWhenDown = .97;
			back.x = 15;
			back.y = 15;
			addChild(back);
			
			add = new Button(atlas.getTexture('AddButton'));
			add.addEventListener(Event.TRIGGERED, onAddButton);
			//add.alphaWhenDisabled = 1;
			add.scaleWhenDown = .93;
			add.x = 535;
			add.y = 75;
			addChild(add);
			
			loanItem = new LoanItem();
			loanItem.x = 135;
			loanItem.y = 125;
			addChild(loanItem);
			
			if(Values.loanItemList.length)
			{
				for(var i:int = 0; i < Values.loanItemList.length; i++)
				{
					if(i == 0)
					{
						loanItem.label = Values.loanItemList[i].name;
						loanItem.amount = Values.loanItemList[i].cost;
					}
					else
					{
						addLoanItem(Values.loanItemList[i].name, Values.loanItemList[i].cost);
					}
				}
			}
			else
			{
				loanItem.amount = Values.loanAmount || 0;
			}
			
			submit = new Button(atlas.getTexture('SubmitButton'), '', atlas.getTexture('SubmitButtonDown'));
			submit.addEventListener(Event.TRIGGERED, onSubmitButton);
			submit.x = 436;
			submit.y = 679;
			addChild(submit);
			
			tradeIn = new LoanAmount();
			addChild(tradeIn);
			
			tradeIn.updateWidth(150);
			tradeIn.updatePosition(318, 73);
			tradeIn.amount = Values.tradeIn || 0;
		}
		
		private function onAddButton(event:Event):void
		{
			addLoanItem();
		}
		
		private function addLoanItem(n:String = undefined, c:Number = undefined):void
		{
			if(itemList.length == 4) return;
			var newLoanItem:LoanItem = new LoanItem(true);
			newLoanItem.removeItem = removeItem;
			newLoanItem.x = loanItem.x;
			newLoanItem.y = loanItem.y + 110 * (itemList.length + 1);
			addChild(newLoanItem);
			
			if(n) newLoanItem.label = n;
			if(c) newLoanItem.amount = c;
			
			itemList.push(newLoanItem);
		}
		
		private function removeItem(value:LoanItem):void
		{
			disableButtons();
			removeChild(value);
			
			for(var i:int = 0; i < itemList.length; i++)
			{
				if(itemList[i] == value)
				{
					itemList.splice(i, 1);
					break;
				}
			}
			
			value.destroy();
			
			if(itemList.length == 0)
			{
				enableButtons();
				return;
			}
			
			var tween:Tween;
			for(i = 0; i < itemList.length; i++)
			{
				tween = new Tween(itemList[i], .5, Transitions.EASE_OUT_BOUNCE);
				tween.animate('y', loanItem.y + 110 * (i + 1));
				tween.onUpdate = itemList[i].updateLabelPositions;
				if(i == itemList.length - 1) tween.onComplete = enableButtons;
				Starling.juggler.add(tween);
			}
		}
		
		private function disableButtons():void
		{
			back.enabled = false;
			add.enabled = false;
			submit.enabled = false;
		}
		
		private function enableButtons():void
		{
			back.enabled = true;
			add.enabled = true;
			submit.enabled = true;
		}
		
		private function onBackButton(event:Event):void
		{	
			app.state = Application.DASHBOARD;
		}
		
		private function onSubmitButton(event:Event):void
		{	
			if(tradeIn.amount <= 0)
			{
				app.showMessage('Trade-in Error', 'Trade-in and cash value required.');
				return;
			}
			
			var percent:Number = loanItem.amount;
			for(var i:int = 0; i < itemList.length; i++)
			{
				percent += itemList[i].amount;
			}
			percent *= .25;
			
			if(tradeIn.amount < percent)
			{
				app.showMessage('Trade-in Error', 'Trade-in and cash value must be at least 25% of total purchase. Please re-enter.');
				return;
			}
			
			Values.tradeIn = tradeIn.amount;
			Values.loanAmount = loanItem.amount - tradeIn.amount;
			Values.loanItemList = new Vector.<LoanItemVO>();
			Values.loanItemList.push(new LoanItemVO(loanItem.label, loanItem.amount));
			
			for(i = 0; i < itemList.length; i++)
			{
				Values.loanItemList.push(new LoanItemVO(itemList[i].label, itemList[i].amount));
				Values.loanAmount += itemList[i].amount;
			}
			
			if(Values.loanAmount < 0)
			{
				// Cutting corners by hardcoding Application path
				app.showMessage('Loan Amount', 'Your trade in amount is greater than your loan total so Loan Amount won\'t be displayed.');
				Values.loanAmount = 0;
			}
			
			app.state = Application.DASHBOARD;
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			for(var i:int = 0; i < itemList.length; i++)
			{
				removeChild(itemList[i]);
				itemList[i].destroy();
				itemList[i] = null;
			}
			itemList = null;
			
			removeChild(tradeIn);
			tradeIn.destroy();
			tradeIn = null;
			
			removeChild(loanItem);
			loanItem.destroy();
			loanItem = null;
			
			back.removeEventListener(Event.TRIGGERED, onBackButton);
			removeChild(back);
			back.dispose();
			back = null;
			
			add.removeEventListener(Event.TRIGGERED, onAddButton);
			removeChild(add);
			add.dispose();
			add = null;
			
			submit.removeEventListener(Event.TRIGGERED, onSubmitButton);
			removeChild(submit);
			submit.dispose();
			submit = null;
			
			this.removeChildren(0, -1, true);
		}
	}
}