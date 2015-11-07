package ch.inaffect.legiapp.helper
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class RequestHandler extends EventDispatcher implements IRequestHandler
	{
		public static const GET_LAST_CHANGES : String = "api/lastchanges";
		public static const GET_FILTER_CITY : String = "api/cities";
		public static const GET_FILTER_CATEGORY : String = "api/categories";
		public static const GET_ALL_OFFERS : String = "api/offers?page=1&pagesize=10000";
		public static const GET_SUPPLIER : String = "api/suppliers/";
		public static const POST_AUTHENTICATION : String = "token";
		public static const POST_REDEEM_OFFER : String = "api/apiuseoffer";
		
		protected var baseUrl : String = "http://de.legi.ch/";
		
		protected var reqReturnValue : *;
		protected var reqErrorMsg : String;
		protected var reqStatus : int;
		
		protected var loader : URLLoader;
		protected var request : URLRequest;
		
		public function RequestHandler()
		{
			super();
			
			request = new URLRequest;
			request.requestHeaders.push(new URLRequestHeader("Accept", "application/json"));
			request.requestHeaders.push(new URLRequestHeader("Accept-Language", "de-CH"));
			
			loader = new URLLoader;
			loader.addEventListener(flash.events.Event.COMPLETE, onComplete);
			loader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
		}
		
		public function load(o:*=null):Boolean
		{
			return true;
		}
		
		public function get data():*
		{
			return reqReturnValue;
		}
		
		public function get errorMessage():String
		{
			return reqErrorMsg;
		}
		
		public function get status():int
		{
			return reqStatus;
		}
		
		protected function onComplete(e : flash.events.Event) : void
		{
			dispatchEventWith(starling.events.Event.COMPLETE);
		}
		
		protected function onLoadError(e : IOErrorEvent) : void
		{
			reqErrorMsg = e.text;
			dispatchEventWith(starling.events.Event.IO_ERROR);
		}
		
		protected function onStatus(e : HTTPStatusEvent) : void
		{
			reqStatus = e.status;
		}
		
		protected function onLoadProgress(e : ProgressEvent) : void
		{}
		
		public function dispose() : void
		{
			try
			{
				loader.close();
			}
			catch(e){}
			
			loader.removeEventListener(flash.events.Event.COMPLETE, onComplete);
			loader.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			
			request = null;
			loader = null;
		}
	}
}