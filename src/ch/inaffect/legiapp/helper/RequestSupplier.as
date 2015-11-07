package ch.inaffect.legiapp.helper
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	import ch.inaffect.legiapp.model.Model;
	
	import feathers.controls.ImageLoader;
	
	import starling.events.Event;
	import starling.utils.ScaleMode;
	
	public class RequestSupplier extends RequestHandler
	{
		public static var EVENT_IMAGE_LOADED : String = "eventImageLoaded";
		public static var EVENT_IMAGE_ERROR : String = "eventImageError";
		
		private var _imgLoader:ImageLoader;
		
		public var flagLoadImage : Boolean = false;
		public var stageWidth : int;
		
		public function RequestSupplier()
		{
			super();
			
			_imgLoader = new ImageLoader;
			_imgLoader.scaleContent = true;
			_imgLoader.maintainAspectRatio = true;
			_imgLoader.scaleMode = ScaleMode.SHOW_ALL;
			_imgLoader.addEventListener(starling.events.Event.COMPLETE, onCompleteLoadingImage);
			_imgLoader.addEventListener(starling.events.Event.IO_ERROR, onErrorLoadingImage);

			request.contentType = "application/json; charset=UTF-8";
			request.method = URLRequestMethod.GET;
		}
		
		override public function load(s : * = null) : Boolean
		{
			request.url = baseUrl + GET_SUPPLIER + s;
			loader.load(request);
			return true;
		}
		
		public function get imageLoader() : ImageLoader
		{
			return _imgLoader;
		}
		
		override protected function onComplete(e : flash.events.Event) : void
		{
			reqReturnValue = JSON.parse(URLLoader(e.currentTarget).data);
			dispatchEventWith(e.type, reqReturnValue);
			
			if(reqReturnValue.mediaImage != null)
			{
				_imgLoader.source = reqReturnValue.mediaImage[Model.getImgVO(stageWidth).url];
			}
		}
		
		override public function dispose() : void
		{
			super.dispose();
			
			_imgLoader.removeEventListener(starling.events.Event.COMPLETE, onCompleteLoadingImage);
			_imgLoader.removeEventListener(starling.events.Event.IO_ERROR, onErrorLoadingImage);
			_imgLoader.dispose();
		}
		
		private function onCompleteLoadingImage(e : starling.events.Event) : void
		{
			dispatchEventWith(EVENT_IMAGE_LOADED);
		}
		
		private function onErrorLoadingImage(e : starling.events.Event) : void
		{
			dispatchEventWith(EVENT_IMAGE_ERROR);
		}
	}
}