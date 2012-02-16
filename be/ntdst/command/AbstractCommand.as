package be.ntdst.command 
{

    import flash.events.EventDispatcher;
	import flash.events.ErrorEvent;
    import flash.events.Event;
	
	import be.ntdst.util.log.Logger;
	import be.ntdst.core.Abstract;
    

    public  class       AbstractCommand 
            extends     EventDispatcher 
            implements  Command {
    
		public static const COMMAND_COMPLETE:String = 'command_complete';
		public static const COMMAND_FAIL:String = 'command_fail';
				
        public function execute(evt:Event=null) :void {
            Logger.error("AbstractCommand: execute method not implemented");
        };

        protected function onCommandComplete() :void {
			if( hasEventListener( AbstractCommand.COMMAND_COMPLETE ) ) {
				dispatchEvent(
					new Event(AbstractCommand.COMMAND_COMPLETE, true, true)
				);
			}
        };

        protected function onCommandFail(errorMessage :String = null) :void {
			Logger.error( this + ": onCommandFail; " + errorMessage);
			
			if( hasEventListener( AbstractCommand.COMMAND_FAIL ) ) {
				dispatchEvent(
					new ErrorEvent(AbstractCommand.COMMAND_FAIL, true, true, errorMessage)
				);
			}
        };
		
		public function AbstractCommand() {
			Abstract.enforce( this, AbstractCommand );
			super( this );
		};
	}
}
