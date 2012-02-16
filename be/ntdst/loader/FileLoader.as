package be.ntdst.loader
{

	import flash.utils.*;	
	import flash.events.*;
	import flash.net.*;
	import flash.system.LoaderContext;
		
	import be.ntdst.core.*;
	
	import be.ntdst.command.*;
	import be.ntdst.util.log.Logger;
	import be.ntdst.loader.strategy.LoadStrategy;
	
	

	/**
	 * FileLoader.as
	 * 
	 * This fileloader uses strategy classes in order to be as flexible as possible. The AssetLoaderStrategy and URLLoaderStrategy
	 * are the most common used. You can use those as a base for creating an xml loader strategy for example.
	 * 
	 * @example
	 * 
	 * 	var f:FileLoader = new FileLoader( new URLLoaderStrategy( URLLoaderStrategy.TEXT ) );
	 *	f.registerAsListener( handleLoader );
	 *  f.load( new URLRequest('data.xml') );	
	 * 
	 */

	public 	class 		FileLoader 
			extends 	AbstractCommand
			implements 	IFileLoader
	{

		private var timeoutTimer:Timer;
		
		
	// -- getter / setter	
		
		private var _name:String = '';
		public function get name() : String {return _name;};
		public function set name(value:String) : void {
			_name = value;
		};	
		
		private var _priority:Number = 3;
		public function get priority() : Number {return _priority;};
		public function set priority(value:Number) : void {
			_priority = value;
		};	
				
		private var _loadrequest:URLRequest = null;
		public function get loadrequest() : URLRequest {return _loadrequest;};
		public function set loadrequest(value:URLRequest) : void {
			_loadrequest = value;
		};	
				
		private var _strategy:LoadStrategy = null;
		public function get strategy() : LoadStrategy {	return _strategy; };
		public function set strategy(value:LoadStrategy) : void {			
			_strategy = value;
			if( value != null ) _strategy.fileloader = this;
		};			
		
		private var _context:LoaderContext;
		public function get context(  ):LoaderContext { return _context  };
		public function set context( value:LoaderContext ):void {
			_context = value;
		};
		
		private var _content:Object;
		public function get content( ):Object { return _content  };
		public function set content( value:Object ):void {
			_content = value;
		};
		
		private var _progress:Number = 0;
		public function get progress( ):Number {
			return _progress;
		};
		
		private var _antiCache:Boolean = false;
		public function get antiCache( ):Boolean { return _antiCache };
		public function set antiCache( value:Boolean ):void {
			_antiCache = value;
		};
		
		private var _prefix:String = '';
		public function get prefix( ):String {return _prefix;};
		public function set prefix( value:String  ):void {
			_prefix = value;
		};
		
		public function FileLoader( _strategy:LoadStrategy = null, request:URLRequest = null, data:URLVariables = null ) {					
			timeoutTimer = new Timer(30000, 1 );
			timeoutTimer.addEventListener( 
					TimerEvent.TIMER_COMPLETE, 
					timeoutHandler 
				);
			
			strategy = _strategy;			
			
			loadrequest = request;
			
			if( data != null ) {
				loadrequest.data = data;
				loadrequest.method = URLRequestMethod.GET;
			}
			
			super( );			
		};
		
		public function registerAsListener( l:Function ):void {
			dustLib::registerStrategyLoaderEvents( this, l );	
		};
		
		public function removeAsListener( l:Function ):void {
			dustLib::unRegisterStrategyLoaderEvents( this, l );				
		};
		
		public function close():void {		
			
			strategy.release();
			loadrequest = null;
			
			if( timeoutTimer ) {
				timeoutTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, timeoutHandler );
				timeoutTimer.reset();
				timeoutTimer = null;
			}

		};
		
		public function load( request:URLRequest = null ):void {
		
			loadrequest = request || loadrequest;

			if ( loadrequest == null || strategy == null ) {
				
				onCommandFail( 
					"invalid FileLoader arguments: " 
					+ ( loadrequest == null ) ? 'no request specified' : ''
					+ ( strategy == null ) ? 'no strategy specified' : ''
						);
						
				return;
			};		

			execute();					
		};
		
		public override function execute(evt:Event = null) :void {
			if ( loadrequest.url.length > 0 ) {
				timeoutTimer.start();
						
				loadrequest.url += !antiCache ? '' : '?c=' + Math.random() * 1000;
				loadrequest.url = prefix + loadrequest.url;
			
				strategy.load(
					loadrequest, 
					( _context != null ) ? _context : null
				);
					
				dispatchEvent( 
					buildEvent( new Event( Event.INIT ) ) 
				);
			}
		};
		
		public override function toString():String {
			return "FileLoader ( "  + priority + " ); "  + loadrequest.url;
		};
		
		
		protected function timeoutHandler( e:TimerEvent ):void {			
			if ( content == null ) {			
				
				onCommandFail( "could not complete load; assset [" + strategy +"] timed out" );
				
				dispatchEvent( 
					buildEvent( new ErrorEvent( ErrorEvent.ERROR ), 'time out' ) 
				);
						
				destroy();	
			}			
		};	
		
		protected function ioErrorHandler(event:Event):void {		
			
			onCommandFail( "could not complete load; [" + strategy +"] not found" );
			
			dispatchEvent( 
				buildEvent(event, (event as IOErrorEvent).text) 
			);				
						
			destroy();
        };
		
		
		protected function httpStatusHandler(event:Event):void {
			dispatchEvent( 
				buildEvent(event, ( event as HTTPStatusEvent ).status as String) 
			);
        };

        protected function openHandler(event:Event):void {			
			timeoutTimer.reset();
			timeoutTimer.start();
			
			dispatchEvent( 
				buildEvent(event) 
			);
        };

        protected function progressHandler(event:Event):void {	
			
			_progress = ProgressEvent(event).bytesLoaded / ProgressEvent(event).bytesTotal;				
			dispatchEvent( 
				buildEvent(event) 
			);
        };

		protected function completeHandler(event:Event):void {
		
			if ( content != null )
			{				
				onCommandComplete();
				
				dispatchEvent( 
					buildEvent(event) 
				);
				
			}
			
			close();					
        };
		
		protected function precompleteHandler(event:Event):void {	
			completeHandler( event );		
        };
		
		protected function buildEvent(event:Event, error:String = ''):FileLoaderEvent {
			var result:FileLoaderEvent = new FileLoaderEvent( event.type, this );
			result.content = content;
			result.error = error;				
			return result;
		};
		
		protected function destroy():void {	
			close();			
			
			strategy
			strategy = null;	
			context = null;		
			content = null;
		};
		

		/**
		 * internal event handlers for the strategies
		 * 
		 */
		final dustLib function registerStrategyLoaderEvents( ev:EventDispatcher, f:Function = null ):void {
			try {
				ev.addEventListener(Event.COMPLETE, f || precompleteHandler);
				ev.addEventListener(HTTPStatusEvent.HTTP_STATUS, f || httpStatusHandler);
				ev.addEventListener(IOErrorEvent.IO_ERROR, f || ioErrorHandler);
				ev.addEventListener(Event.OPEN, f || openHandler);
				ev.addEventListener(ProgressEvent.PROGRESS, f || progressHandler);
			}
			catch( e:Error ){}
		};
		
		final dustLib function unRegisterStrategyLoaderEvents( ev:EventDispatcher, f:Function = null ):void {
			try {
				ev.removeEventListener(Event.COMPLETE, f || precompleteHandler);
				ev.removeEventListener(HTTPStatusEvent.HTTP_STATUS, f || httpStatusHandler);
				ev.removeEventListener(IOErrorEvent.IO_ERROR, f || ioErrorHandler);
				ev.removeEventListener(Event.OPEN, f || openHandler);
				ev.removeEventListener(ProgressEvent.PROGRESS, f || progressHandler);
			}
			catch( e:Error ){}
		};
		
	}
	
}