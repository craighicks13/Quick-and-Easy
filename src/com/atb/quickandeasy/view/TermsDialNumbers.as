package com.atb.quickandeasy.view
{
	import com.atb.quickandeasy.interfaces.IInteractiveElement;
	import com.atb.quickandeasy.model.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	public class TermsDialNumbers extends Sprite implements IInteractiveElement
	{
		private var current_number:Number = 0;
		public var set_number:Number = 1;
		public var onChange:Function;
		private var atlas:TextureAtlas;
		private var num:Image;
		
		public function TermsDialNumbers()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			atlas = Assets.getTextureAtlas();
			
			setNumber();
		}
		
		private function setNumber():void
		{
			if(num)
			{
				removeChild(num);
				num.dispose();
			}
			num = new Image(atlas.getTexture('Dial' + set_number));
			addChild(num);
			
			switch(set_number)
			{
				case 1:
					num.x = -82;
					num.y = 52;
					break;
				case 2:
					num.x = -104;
					num.y = 1;
					break;
				case 3:
					num.x = -101;
					num.y = -49;
					break;
				case 4:
					num.x = -76;
					num.y = -86;					
					break;
				case 5:
					num.x = -37;
					num.y = -107;					
					break;
				case 6:
					num.x = 14;
					num.y = -108;
					break;
				case 7:
					num.x = 54;
					num.y = -86;
					break;
				case 8:
					num.x = 78;
					num.y = -49;
					break;
				case 9:
					num.x = 82;
					num.y = 0;
					break;
				case 10:
					num.x = 61;
					num.y = 50;
					break;
			}
			
			current_number = set_number;
			
			if(onChange != null)
			{
				onChange();
				Assets.termSound.play();
			}
		}
		
		public function get cost():Number
		{
			var num:Number;
			switch(set_number)
			{
				case 1:
					num = 8;
					break;
				case 2:
					num = 10;
					break;
				case 3:
					num = 12;
					break;
				case 4:
					num = 14;					
					break;
				case 5:
					num = 16;					
					break;
				case 6:
					num = 18;
					break;
				case 7:
					num = 20;
					break;
				case 8:
					num = 22;
					break;
				case 9:
					num = 24;
					break;
				case 10:
					num = 26;
					break;
			}
			return num;
		}
		
		public function update():void
		{
			if(current_number != set_number) setNumber();
		}
		
		public function destroy():void
		{
			removeChildren(0, -1, true);
		}
	}
}