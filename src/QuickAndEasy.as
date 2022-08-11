package
{
	import com.atb.quickandeasy.model.Assets;
	import com.atb.quickandeasy.view.Application;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(frameRate="60", backgroundColor='0x000000', width="1024", height="768")]
	public class QuickAndEasy extends Sprite
	{
		[Embed(source="../assets/loading/loading-screen.png")]
		public static const DefaultBackground:Class;
		
		[Embed(source="../assets/loading/loading-spinner.png")]
		public static const LoadingSpinner:Class;
		
		private var s:Starling;
		
		private var bg:Bitmap;
		private var spinner:Bitmap;
		private var spinner_clip:Sprite;
		public function QuickAndEasy()
		{			
			addEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:flash.events.Event):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
			var screenWidth:int  = 1024; // stage.fullScreenWidth;
			var screenHeight:int = 768; // stage.fullScreenHeight;
			
			var viewPort:Rectangle = new Rectangle(0, 0, screenWidth, screenHeight);
			
			bg = Bitmap(new DefaultBackground());
			bg.cacheAsBitmap = false;
			addChild(bg);
			
			spinner_clip = new Sprite();
			spinner_clip.x = screenWidth *.5;
			spinner_clip.y = screenHeight *.65;
			addChild(spinner_clip);
			
			spinner = Bitmap(new LoadingSpinner());
			spinner.cacheAsBitmap = true;
			spinner.x = spinner.width * -0.5;
			spinner.y = spinner.height * -0.5;
			spinner_clip.addChild(spinner);
			
			addEventListener(flash.events.Event.ENTER_FRAME, loop);
			
			s = new Starling(Application, stage, viewPort);
			s.stage.stageWidth = 1024;
			s.stage.stageHeight = 768;
			s.addEventListener(starling.events.Event.ROOT_CREATED, removeBackground);
			s.start();
		}
		
		protected function loop(event:flash.events.Event):void
		{
			spinner_clip.rotation += 15;
		}
		
		
		protected function removeBackground(event:starling.events.Event):void
		{
			s.removeEventListener(starling.events.Event.ROOT_CREATED, removeBackground);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			removeEventListener(flash.events.Event.ENTER_FRAME, loop);
			
			spinner_clip.removeChild(spinner);
			spinner.bitmapData.dispose();
			spinner = null;
			
			removeChild(spinner_clip);
			spinner_clip = null;
			
			removeChild(bg);
			bg.bitmapData.dispose();
			bg = null;
			
		}
	}
}