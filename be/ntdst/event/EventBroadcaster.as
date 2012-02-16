package be.ntdst.event
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    
	import be.ntdst.core.Singleton;
	
	/**
	 * ...
	 * @author Stefan Vandermeulen
	 * 
	 * Singleton event dispatcher for global accesable events, mostly used with a frontcontroller
	 *  
	 * @example
	 * EventBroadcaster.getInstance().dispatchEvent( new Event( Event.COMPLETE ) );
	 * 
	 */	
	
    final public 	class 	EventBroadcaster 
					extends EventDispatcher
    {
		private static var _instance:EventBroadcaster = null;
		
        public static function getInstance() :EventBroadcaster {
            if (_instance == null) {
                _instance = new EventBroadcaster();
            }
            return _instance;
        };
        
		public function EventBroadcaster() {
			Singleton.enforce( this );
		};
    }
}

