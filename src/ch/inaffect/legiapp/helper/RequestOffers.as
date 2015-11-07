package ch.inaffect.legiapp.helper
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	import starling.events.Event;

	public class RequestOffers extends RequestHandler implements IRequestHandler
	{
		private var _status:int;
		private var _error:String;
		private var _data : Array;
		
		public function RequestOffers()
		{
			super();
			
			request.contentType = "application/json; charset=UTF-8";
			request.method = URLRequestMethod.GET;
			request.url = baseUrl + GET_ALL_OFFERS;
			
			loader.load(request);
		}
		
		override public function get data() : *
		{
			return _data as Object;
		}
		
		override protected function onComplete(e : flash.events.Event) : void
		{
			_data = JSON.parse(URLLoader(e.currentTarget).data).result;
			dispatchEventWith(starling.events.Event.COMPLETE, false, _data);
		}
		
		override protected function onLoadError(e : IOErrorEvent) : void
		{
			_error = e.text;
			super.onLoadError(e);
		}
		
		override protected function onStatus(e : HTTPStatusEvent) : void
		{
			_status = e.status;
		}
	}
}