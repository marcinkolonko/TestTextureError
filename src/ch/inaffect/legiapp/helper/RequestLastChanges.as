package ch.inaffect.legiapp.helper
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	import starling.events.Event;

	public class RequestLastChanges extends RequestHandler
	{
		public function RequestLastChanges()
		{
			super();
			
			request.contentType = "application/json; charset=UTF-8";
			request.method = URLRequestMethod.GET;
			request.url = baseUrl + GET_LAST_CHANGES;
			
			loader.load(request);
		}
		
		override protected function onComplete(e : flash.events.Event) : void
		{
			reqReturnValue = JSON.parse(URLLoader(e.currentTarget).data);
			dispatchEventWith(starling.events.Event.COMPLETE, false, reqReturnValue as Number);
		}
	}
}