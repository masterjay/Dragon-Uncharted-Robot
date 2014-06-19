package
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class WebCommunicationHelper
	{
		private static var _instance:WebCommunicationHelper;
		
		public static function get instance():WebCommunicationHelper
		{
			if(null == _instance)
			{
				_instance = new WebCommunicationHelper(new SingletonForcer);
			}
			return _instance;
		}
		
		public function WebCommunicationHelper($SF:SingletonForcer)
		{
		}
		
		public function request($url:String, $json:String, $method:String = URLRequestMethod.POST, 
								$completedHandler:Function = null, $httpStatusHandler:Function = null, 
								$securityErrorHandler:Function = null, $ioErrorHandler:Function = null):void
		{
			var var_:URLVariables = new URLVariables();
			var_.json = $json;
			var req_:URLRequest = new URLRequest();
			req_.url = $url;
			req_.method = $method;
			req_.data = var_;
			var loader_:URLLoader = new URLLoader();
			loader_.dataFormat = URLLoaderDataFormat.TEXT;
			loader_.addEventListener(Event.COMPLETE, ($completedHandler == null ? completedHandler : $completedHandler), false, 0, true);
			loader_.addEventListener(HTTPStatusEvent.HTTP_STATUS, ($httpStatusHandler == null ? httpStatusHandler : $httpStatusHandler), false, 0, true);
			loader_.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ($securityErrorHandler == null ? securityErrorHandler:$securityErrorHandler), false, 0, true);
			loader_.addEventListener(IOErrorEvent.IO_ERROR, ($ioErrorHandler == null ? ioErrorHandler : $ioErrorHandler), false, 0, true);
			loader_.load(req_);
		}
		
		private function completedHandler(e:Event):void
		{
			trace(e.target.data);
		}
		
		private function httpStatusHandler(e:Event):void
		{
			trace("httpStatusHandler:" + e);
		}
		
		private function securityErrorHandler(e:Event):void
		{
			trace("securityErrorHandler:" + e);
		}
		
		private function ioErrorHandler(e:Event):void
		{
			trace("ioErrorHandler: " + e);
		}
	}
}

class SingletonForcer{}