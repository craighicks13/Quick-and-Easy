package com.atb.quickandeasy.view
{
	import com.atb.quickandeasy.model.Assets;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class NativeDialog extends Sprite
	{
		public var buttonClicked:Function;
		private var button:Button;
		
		private var title:String;
		private var message:String;
		private var button_text:String;
		private var bg:Image;
		private var dTitle:TextField;
		private var dMessage:TextField;
		
		public function NativeDialog()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function showNativeDialog(title:String, message:String, button_text:String):void
		{
			this.title = title;
			this.message = message;
			this.button_text = button_text;
		}
		
		public override function dispose():void
		{
			button.removeEventListener(Event.TRIGGERED, onButtonClicked);
			removeChild(button);
			button.dispose();
			button = null;
			
			removeChild(dTitle);
			dTitle.dispose();
			dTitle = null;
			
			removeChild(dMessage);
			dMessage.dispose();
			dMessage = null;
			
			removeChild(bg);
			bg.dispose();
			bg = null;
			
			super.dispose();
		}
		
		protected function init(event:Event):void
		{
			var atlas:TextureAtlas = Assets.getTextureAtlas();
			
			bg = new Image(atlas.getTexture('DialogWindowBG'));
			bg.touchable = false;
			addChild(bg);
			
			dTitle = new TextField(335, 30, this.title, 'Arial', 20, 0xFFFFFF, true);
			dTitle.autoScale = true;
			dTitle.hAlign = HAlign.LEFT;
			dTitle.x = 15;
			dTitle.y = 5;
			addChild(dTitle);
			
			dMessage = new TextField(335, 150, this.message, 'Arial', 16, 0xFFFFFF, true);
			dMessage.autoScale = false;
			dMessage.hAlign = HAlign.LEFT;
			dMessage.vAlign = VAlign.TOP;
			dMessage.x = 15;
			dMessage.y = 45;
			addChild(dMessage);
			
			button = new Button(atlas.getTexture('MultipleLoanAmountsButton'), this.button_text);
			button.addEventListener(Event.TRIGGERED, onButtonClicked);
			button.y = 200;
			button.x = 135;
			addChild(button);
		}
		
		private function onButtonClicked(event:Event):void
		{
			if(buttonClicked != null) buttonClicked();
		}
	}
}