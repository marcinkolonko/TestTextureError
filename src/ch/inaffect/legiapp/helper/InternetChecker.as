package ch.inaffect.legiapp.helper
{
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	
	import air.net.URLMonitor;
	
	import starling.events.EventDispatcher;
	
	public class InternetChecker extends EventDispatcher
	{
		public static const EVENT_NET_STATUS_CHANGED : String = "netStatusChanged";
		public static var NET_STATUS : Boolean = false;
		
		private var _callback : Array = new Array();
		private static var _instance:InternetChecker;
		
		public static function getInstance() : InternetChecker
		{
			if(!_instance)
			{
				new InternetChecker();
			} 
			return _instance;
		}
		
		public function InternetChecker() : void
		{
			if(_instance) throw new Error("Singleton... use getInstance()");
			_instance = this;
			
			startChecking();
		}
		
		private function startChecking() : void
		{
			var url:URLRequest = new URLRequest("http://www.google.ch");
			url.method = "HEAD";
			
			var monitor : URLMonitor = new URLMonitor(url);
			monitor.addEventListener(StatusEvent.STATUS, netConnectivity);
			monitor.pollInterval = 3000;
			monitor.start();
		}
		
		private function netConnectivity(e : StatusEvent):void
		{
			NET_STATUS = e.target.available;
			dispatchEventWith(EVENT_NET_STATUS_CHANGED);
		}
	}
}