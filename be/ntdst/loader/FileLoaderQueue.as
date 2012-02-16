package be.ntdst.loader
{
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	import be.ntdst.util.log.Logger;
	import be.ntdst.loader.strategy.*;


	/**
	* @author Stefan Vandermeulen - netdust.be
	* @version 0.1
	*/
	
	public class 	FileLoaderQueue 
		   extends  FileLoader
	{
		
		public static const LOADERCOMPLETE:String = "onLoaderComplete";
		public static const QUEUECOMPLETE:String = "onQueueComplete";
		public static const QUEUEFAILED:String = "onQueueFailed";
		
		private var _currentLoader:IFileLoader;
		private var _abortOnFail:Boolean;		
		private var _loaderQueue:Array;
		private var _length:int;
		
		override public function get progress( ):Number {
			return FileLoader( _currentLoader ).progress / _length + ( ( _length - length() - 1 ) * (1/_length) );
		};
		
		public function get loader( ):IFileLoader {
			return _currentLoader;
		};
		

		private var _strategy:LoadStrategy = null;
		override public function set strategy(value:LoadStrategy) : void {
			if( loader != null ) {
				loader.strategy = value;
			};
		};	
		
		override public function get strategy() : LoadStrategy {
			if( loader != null ) {
				return loader.strategy;
			}
			return null;
		};
		
		public function FileLoaderQueue(abortOnFail:Boolean = true) 
		{
			super();
			_length = 0;
			_abortOnFail = abortOnFail;
			_loaderQueue = new Array();
		};
		
		override public function registerAsListener( l:Function ):void {
			super.registerAsListener( l );
			addEventListener(QUEUECOMPLETE, l);
			addEventListener(QUEUEFAILED, l);
		};
		
		override public function removeAsListener( l:Function ):void {
			super.removeAsListener( l );	
			removeEventListener(QUEUECOMPLETE, l);
			removeEventListener(QUEUEFAILED, l);
		};
		
		override public function load( request:URLRequest = null ):void {
			
			dispatchEvent( 
				buildEvent( new Event( Event.INIT ) ) 
			);
			
			execute();					
		};
		
		public override function execute(evt:Event = null) :void {
		
			if ( _length == 0 ) _length = length();
			
			_currentLoader = dequeue();
			
			if ( _currentLoader != null ) 
			{				
				_currentLoader.registerAsListener( loadHandler );
				_currentLoader.load( );
			}
			else {				
				onQueueComplete();	
			}

		};
		
		override public function close():void 
		{
			try {
			_currentLoader.removeAsListener( loadHandler );
			_currentLoader.close();
			} catch ( e:Error ) { }
			
			super.close();			
		};	
		
		public function peek():IFileLoader
        {
            return _loaderQueue[0];
        }
		
		public function dequeue():IFileLoader
        {
            return _loaderQueue.shift();
        }
		
		public function addFileLoader( id:String, loader:IFileLoader, priority:Number = 3 ):Boolean {
			loader.priority = priority + ( _loaderQueue.length / 1000 ); // bug fix for sortOn :(		
		    loader.name = id;
			
			_loaderQueue.push( loader );					
            _loaderQueue.sortOn( 'priority', Array.NUMERIC );	

			return true;
		};
		
		public function removeFileLoader( loader:IFileLoader ):Boolean {
			var i:int = _loaderQueue.indexOf(loader);
            if (i != -1) {
                _loaderQueue.splice(i, 1);        
                return true;
            }       
            return false;
		};
		
		public function clear():void
        {
            _loaderQueue = new Array();
        };

        public function isEmpty():Boolean
        {
            return _loaderQueue.length==0;
        };
		
		public function length():Number 
		{
            return _loaderQueue.length;
        };
		
		override protected function destroy():void {	
			super.destroy();
			_currentLoader = null;
			_loaderQueue = [];
		};
		
		
		public override function toString():String {
			return "FileLoaderQueue";
		};
		
		override protected function buildEvent(event:Event, error:String = ''):FileLoaderEvent {
			var result:FileLoaderEvent = super.buildEvent( event, error );
			if ( loader != null &&  loader.content != null ) {
				result.content = loader.content;			
			}
			return result;
		};
		
		//-- handlers

		protected function loadHandler( e:Event ) :void {
	
			if ( !(e is FileLoaderEvent) ) return;
			switch( e.type ) 
			{
				case Event.COMPLETE:
					dispatchEvent(  buildEvent( new Event( LOADERCOMPLETE ) ) );
					FileLoaderEvent( e ).loader.removeAsListener( loadHandler );
					execute();	
					break;				
				case IOErrorEvent.IO_ERROR:
					dispatchEvent(  buildEvent( e, (e as FileLoaderEvent).error ) );
					FileLoaderEvent( e ).loader.removeAsListener( loadHandler );
					if (_abortOnFail) {
						onQueueFail(FileLoaderEvent( e ).error);
					}
					else execute();
					break;
				case HTTPStatusEvent.HTTP_STATUS:
				case ProgressEvent.PROGRESS:	
				case Event.OPEN:
					dispatchEvent( 
						buildEvent( e )
					);
					break;		
			};
		};
		

		private function onQueueComplete():void {
			dispatchEvent(  buildEvent( new Event( Event.COMPLETE ) ) );
			dispatchEvent(  buildEvent( new Event( QUEUECOMPLETE ) ) );		
						
			_currentLoader = null;
			_loaderQueue = [];
			_length = 0;
		};
		
		private function onQueueFail(mssg:String):void {	
			onCommandFail( 
					"FileLoaderQueue failed loading and aborted: " + _currentLoader.loadrequest.url
						);
			dispatchEvent( buildEvent( new Event( QUEUEFAILED ), mssg ) );		
			_currentLoader = null;
 			_loaderQueue = [];
			_length = 0;
		};
		
	}
	
}