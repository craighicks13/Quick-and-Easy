package com.atb.quickandeasy.view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class LoadingGauge extends Sprite
	{
		[Embed(source="../assets/loading/background.png")]
		public static const DefaultBackground:Class;
		
		[Embed(source="../assets/loading/needle.png")]
		public static const LoadingNeedle:Class;
		
		[Embed(source="../assets/loading/screw.png")]
		public static const LoadingScrew:Class;
		private var bg:Bitmap;
		public var fillAmount:int;
		
		public function LoadingGauge()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			bg = Bitmap(new DefaultBackground());
			bg.cacheAsBitmap = true;
			bg.x = -42;
			bg.y = -40;
			addChild(bg);
		}
	}
}