package ch.inaffect.legiapp.helper
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	import starling.events.Event;

	public class RequestToken extends RequestHandler
	{
		public function RequestToken()
		{
			super();
			
			request.contentType = "application/x-www-form-urlencoded; charset=UTF-8";
			request.method = URLRequestMethod.POST;
			request.url = baseUrl + POST_AUTHENTICATION;
		}
		
		override public function load(urlVars:*=null):Boolean
		{
			request.data = urlVars;
			loader.load(request);
			
			return true;
		}
		
		override protected function onComplete(e : flash.events.Event) : void
		{
			reqReturnValue = JSON.parse(URLLoader(e.currentTarget).data);
			dispatchEventWith(starling.events.Event.COMPLETE, false, reqReturnValue);
		}
	}
}