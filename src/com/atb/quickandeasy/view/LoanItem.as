package com.atb.quickandeasy.view
{
	import com.atb.quickandeasy.interfaces.IInteractiveElement;
	import com.atb.quickandeasy.model.Assets;
	import com.atb.quickandeasy.model.Values;
	
	import flash.geom.Point;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	public class LoanItem extends Sprite implements IInteractiveElement
	{
		private var _removeable:Boolean;
		private var loanItem:Image;
		private var _remove:Button;
		private var _cost:LoanAmount;
		private var _label:LoanName;
		private var _pt:Point;
		
		public var removeItem:Function;
		
		public function LoanItem(removeable:Boolean = false)
		{
			_removeable = removeable;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var atlas:TextureAtlas = Assets.getTextureAtlas();
			
			loanItem = new Image(atlas.getTexture('MultipleLoanItem'));
			loanItem.touchable = false;
			addChild(loanItem);
			
			if(_removeable)
			{
				_remove = new Button(atlas.getTexture('DeleteButton'));
				_remove.addEventListener(Event.TRIGGERED, onRemoveItem);
				_remove.x = 775;
				_remove.y = 50;
				addChild(_remove);
			}
			
			_cost = new LoanAmount();
			addChild(_cost);
			
			_label = new LoanName();
			addChild(_label);
			
			updateLabelPositions();
		}
		
		public function updateLabelPositions():void
		{
			_pt = localToGlobal(new Point(loanItem.x, loanItem.y));
			_cost.updatePosition(_pt.x + 404, _pt.y + 41);
			_label.updatePosition(_pt.x + 25, _pt.y + 41);
			
		}
		
		protected function onRemoveItem(event:Event):void
		{
			if(removeItem != null) removeItem(this);
		}
		
		public function set amount(value:Number):void
		{
			_cost.amount = value;
		}
		
		public function get amount():Number
		{
			return _cost.amount;
		}
		
		public function set label(value:String):void
		{
			_label.text = value;
		}
		
		public function get label():String
		{
			return _label.text;
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			if(_remove) _remove.removeEventListener(Event.TRIGGERED, onRemoveItem);
			
			removeChild(_cost);
			_cost.destroy();
			_cost = null;
			
			removeChild(_label);
			_label.destroy();
			_label = null;
			
			removeChildren(0, -1, true);
		}
	}
}