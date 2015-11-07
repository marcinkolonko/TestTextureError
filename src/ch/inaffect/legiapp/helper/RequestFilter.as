package ch.inaffect.legiapp.helper
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;

	public class RequestFilter extends RequestHandler
	{
		private var _cities : Array;
		private var _categories : Array;
		
		public function RequestFilter()
		{
			super();
			
			request.contentType = "application/json; charset=UTF-8";
			request.method = URLRequestMethod.GET;
			request.url = baseUrl + GET_FILTER_CITY;
			
			loader.load(request);
		}
		
		public function get cities() : Array
		{
			return _cities;
		}
		
		public function get categories() : Array
		{
			return _categories;
		}
		
		override protected function onComplete(e : flash.events.Event):void
		{
			var result : Array = JSON.parse(URLLoader(e.target).data) as Array;
			var type : String = result[0].mediaImage.mediaImageType;
			
			if(type == EnumMediaImageType.CATEGORY)
			{
				_categories = new Array();
				_categories = result;
				
				if(_cities == null)
				{
					request.url = baseUrl + GET_FILTER_CITY;
					loader.load(request);	
				}
			}
			else
			{
				_cities = new Array();
				_cities = result;
				
				if(_categories == null)
				{
					request.url = baseUrl + GET_FILTER_CATEGORY;
					loader.load(request);	
				}
			}
			
			if(_cities && _categories) super.onComplete(e);
		}
	}
}