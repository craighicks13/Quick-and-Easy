package com.atb.quickandeasy.model
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;

	public class SubmitData
	{
		public static const SEND_DATA_URL:String = 'http://www.atbquickandeasy.com/Webservices/Application.asmx/Submit';
		public static const DESTINATION_URL:String = 'http://www.atbquickandeasy.com/?applicationId=';
		public static const SUBMIT_SUCCESS_TEST:String = 'http://atb.dev.zgm.ca/Webservices/Application.asmx/SubmitSuccess';
		public static const SUBMIT_FAILURE_TEST:String = 'http://atb.dev.zgm.ca/Webservices/Application.asmx/SubmitFail';

		public var onSendError:Function;
		public var onSendSuccess:Function;
		private var l:URLLoader;
		
		public function SubmitData() {}
		
		public function sendData(xml:XML):void
		{
			var r:URLRequest = new URLRequest(SubmitData.SEND_DATA_URL);
			r.method = URLRequestMethod.POST;
			r.contentType = "text/xml";
			
			var v:URLVariables = new URLVariables();
			v.op = xml;
			
			r.data = xml.toXMLString();
			
			l = new URLLoader();
			addListeners();
			l.load(r);
		}
		
		protected function addListeners():void
		{
			l.addEventListener(Event.COMPLETE, onDataSent);
			l.addEventListener(Event.OPEN, openHandler);
			l.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			l.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			l.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			l.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		protected function removeListeners():void
		{
			l.removeEventListener(Event.COMPLETE, onDataSent);
			l.removeEventListener(Event.OPEN, openHandler);
			l.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			l.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			l.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			l.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		protected function onDataSent(event:Event):void
		{
			removeListeners();
			
			//trace('onDataSent', event.target.data);
			
			var rd:Object = JSON.parse(event.target.data);
			if(rd.IsError == 'True')
			{
				if(onSendError != null) onSendError("Submission Data Error", rd.ErrorLog);
			}
			else
			{
				navigateToURL(new URLRequest(DESTINATION_URL + rd.RawData.ID));
				if(onSendSuccess != null) onSendSuccess();
			}
		}
		
		private function openHandler(event:Event):void 
		{
			trace("openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void 
		{
			trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			removeListeners();
			if(onSendError != null) onSendError("Security Error", event.toString());
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void 
		{
			trace("httpStatusHandler: " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void 
		{
			removeListeners();
			if(onSendError != null) onSendError("IO Error", event.toString());
		}
	}
}