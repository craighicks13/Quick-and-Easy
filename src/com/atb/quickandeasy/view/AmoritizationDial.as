package com.atb.quickandeasy.view
{
	import com.atb.quickandeasy.interfaces.IInteractiveElement;
	import com.atb.quickandeasy.model.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	public class AmoritizationDial extends Sprite implements IInteractiveElement
	{
		public function AmoritizationDial()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var atlas:TextureAtlas = Assets.getTextureAtlas();
			
			var top:Image = new Image(atlas.getTexture('AmoritizationSpinner1'));
			addChild(top);
			
			var bottom:Image = new Image(atlas.getTexture('AmoritizationSpinner2'));
			bottom.y = top.height;
			addChild(bottom);
			
			this.flatten();
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			this.unflatten();
			this.removeChildren(0, -1, true);
		}
	}
}