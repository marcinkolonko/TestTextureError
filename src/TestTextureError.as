package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import feathers.utils.ScreenDensityScaleFactorManager;
	
	import starling.core.Starling;
	
	import ch.inaffect.legiapp.Main;
	
	[SWF(frameRate="60", backgroundColor="#f0f0f0")]
	public class TestTextureError extends Sprite
	{
		private var _starling:Starling;
		private var _scaler:ScreenDensityScaleFactorManager;
		
		public function TestTextureError()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			loaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		protected function onLoadComplete(event:Event):void
		{
			loaderInfo.removeEventListener(Event.COMPLETE,onLoadComplete);
			
			Starling.handleLostContext = true;
			
			_starling = new Starling(Main, stage);
			_scaler = new ScreenDensityScaleFactorManager(_starling);
			_starling.start();
		}
	}
}