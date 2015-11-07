package ch.inaffect.legiapp.helper
{
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;

	public class RequestRedeemOffers extends RequestHandler
	{
		public function RequestRedeemOffers()
		{
			super();
			
			var so : StorageHandler = StorageHandler.getInstance();
			
			request.requestHeaders.push(new URLRequestHeader("Authorization", "bearer " + so.token));
			request.contentType = "application/json; charset=UTF-8";
			request.method = URLRequestMethod.POST;
			request.url = baseUrl + POST_REDEEM_OFFER;
		}
		
		override public function load(a : * = null) : Boolean
		{
			var s : String = JSON.stringify(a);
			if(s != null && s.length > 0)
			{
				request.data = s;
				loader.load(request);
				return true;
			}
			return false;
		}
	}
}