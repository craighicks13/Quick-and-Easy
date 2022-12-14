package com.atb.quickandeasy.controller
{	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class MainLoader extends Sprite
	{
		private var loader:Loader;
		public var gauge:MovieClip;

		private var t:Timer;
		private var startTime:int;
		
		public function MainLoader()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		final protected function onLoadProgress(event:TimerEvent):void
		{
			var min:int = Math.min(int((getTimer() - startTime) / 5000 * 100), int(loader.contentLoaderInfo.bytesLoaded / loader.contentLoaderInfo.bytesTotal * 100));
			gauge.gotoAndStop(Math.max(min, gauge.currentFrame));
			
			if(gauge.currentFrame >= 100) onLoadComplete(null);
		}
		
		final protected function onLoadComplete(event:Event):void
		{
			t.stop();
			t.removeEventListener(TimerEvent.TIMER, onLoadProgress);
			t = null;
			
			removeChildren();
			addChildAt(loader.content, 0);
		}
		
		final protected function onLoadError(event:IOErrorEvent):void
		{
			trace(event);
		}

		final protected function initialize(event:Event):void
		{
			this.cacheAsBitmap = true;
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			t = new Timer(100);
			t.addEventListener(TimerEvent.TIMER, onLoadProgress);
			
			startTime = getTimer();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
						
			var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;
			var movie:String = paramObj.main || "QuickAndEasy.swf";
			
			loader = new Loader();
			//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress, false, 0, true);
			//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError, false, 0, true);
			loader.load(new URLRequest(movie)); // + "?" + new Date().getTime()));
			
			t.start();
		}
	}
}
