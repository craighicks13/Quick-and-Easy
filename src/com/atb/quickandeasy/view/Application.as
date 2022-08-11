package com.atb.quickandeasy.view
{
	import com.atb.quickandeasy.interfaces.IApplicationState;
	import com.atb.quickandeasy.model.Assets;
	
	import flash.events.Event;
	import flash.text.TextField;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Application extends Sprite
	{
		public static const DASHBOARD:String = 'dashboard';
		public static const MULTIPLE_LOANS:String = 'multiple loans';
		public static const APPROVAL_SCREEN:String = 'approval screen';
		public static var CURRENT_STATE:String;

		private static var current_state:IApplicationState;
		public static var onOpenWebView:Function;
		
		public static var paused:Boolean = false;
		
		private var dialog:NativeDialog;
		
		public function Application()
		{
			addEventListener(starling.events.Event.ADDED_TO_STAGE, init);
		}
		
		final protected function loop(event:starling.events.Event):void
		{
			if(current_state != null && paused == false) current_state.update();
		}
		
		final public function set state(value:String):void
		{
			if(current_state)
			{
				removeChild(Sprite(current_state));
				current_state.destroy();
				current_state = null;
			}
			
			switch(value)
			{
				case Application.DASHBOARD:
					current_state = new DashBoard(this);					
					break;
				case Application.MULTIPLE_LOANS:
					current_state = new MultipleLoans(this);
					break;
				case Application.APPROVAL_SCREEN:
					current_state = new ApprovalScreen(this);
					break;
			}
			addChild(Sprite(current_state));
			CURRENT_STATE = value;
		}
		
		final public function openWebView():void
		{
			if(onOpenWebView != null) onOpenWebView();
		}
		
		final public function showMessage(title:String, message:String, button_text:String = ""):void
		{
			paused = true;
			Sprite(current_state).touchable = false;
			
			for (var i:int; i < Starling.current.nativeOverlay.numChildren; i++)
			{
				if(Starling.current.nativeOverlay.getChildAt(i) is TextField)
				{
					Starling.current.nativeOverlay.getChildAt(i).visible = false;
				}
			}
			
			dialog = new NativeDialog();
			dialog.buttonClicked = messageWindowButtonClicked;
			dialog.showNativeDialog(title, message, button_text);
			addChild(dialog);
			
			dialog.x = 512 - dialog.width *.5;
			dialog.y = 382 - dialog.height *.5;
		}
		
		final protected function messageWindowButtonClicked():void
		{
			dialog.dispose();
			
			for (var i:int; i < Starling.current.nativeOverlay.numChildren; i++)
			{
				Starling.current.nativeOverlay.getChildAt(i).visible = true;
			}
			
			Sprite(current_state).touchable = true;
			paused = false;
		}
		
		final protected function init(event:starling.events.Event):void
		{
			removeEventListener(starling.events.Event.ADDED_TO_STAGE, init);
			
			//Starling.current.showStats = true;
			
			Assets.scale = Starling.contentScaleFactor;
			Assets.init();
			
			Assets.startSound.play();
			
			this.state = Application.DASHBOARD;
			
			this.addEventListener(starling.events.Event.ENTER_FRAME, loop);
		}
	}
}