package be.ntdst.event
{

	/**
	* ...
	* @author Stefan Vandermeulen - netdust.be
	*/
	
	import flash.events.Event;	
	import flash.utils.Dictionary;
	import flash.events.IEventDispatcher;
	
	import be.ntdst.core.*;	
	import be.ntdst.command.*;
	import be.ntdst.util.log.Logger;		
	
	/**
	 * ...
	 * @author Stefan Vandermeulen
	 * 
	 * FrontController for use in a mvc+f architecture. A frontcontroller will trigger Commands by using events
	 * usually a EventBroadcaster instance is used, but you can use any other eventdispatcher. For instance you can
	 * add the top displayobject as a dispatcher. every event that originates from a displayobject and that bubbles up the chain
	 * will get captured by the frontcontroller
	 * 
	 * @example
	 *  // set documentClass of your project that contains all displayobjects as eventListener
	 *  FrontController.getInstance().eventListener = this 
	 *  FrontController.getInstance().register( Event.USER_CLICK, new GetUserCommand() );
	 *  
	 *  // dispatch an event from a displayobject on stage and set bubbling to true
	 *  someView.dispatchEvent( new Event( Event.USER_CLICK, true ) ) 
	 * 
	 * 
	 * @example
	 * FrontController.register( Event.GET_DATA, new GetDataCommand() );
	 * 
	 * // to trigger the GetDataCommand.execute() method, broadcast an event like this:
	 * EventBroadcaster.getInstance().dispatchEvent( new Event( Event.GET_DATA ) )
	 * 
	 */	
	
	final public class 	 FrontController 
				 extends Locator
	{
		
		private static var _instance:FrontController = null;
       
        public static function getInstance() :FrontController {
            if (_instance == null) {
                _instance = new FrontController();
            }
            return _instance;
        };
		
		private var _eventListener:IEventDispatcher;
		public function set eventListener(ed:IEventDispatcher):void 
		{
			_eventListener = ed;
		}
		
		public function FrontController() {
			Singleton.enforce( this );
		}

		public function registerCommand( name:String, o:Command ):Boolean
		{
			
			if ( !(o is Command) ) {
				Logger.error( this + " - ["+o+"] instance does not implement Command interface" );
				return false;
			};
			
			if ( (_eventListener == null) ) {
				Logger.error( this + " - instance does not have a listener; EventBroadcaster added as listener" );
				_eventListener = EventBroadcaster.getInstance();
			};
			
			if ( super.register( name, o as Command ) ) {
				_eventListener.addEventListener( name, _executeCommand, true );
				return true;
			};
			
			return false;			
		};		

		public override function unregister( name:String ):Boolean
		{
			if( super.unregister( name ) ) {
				_eventListener.removeEventListener( name, _executeCommand );
				return true;
			};
			
		 	return false;
		};
		
		public function locateCommand( name:String ):Command
		{
			return super.locate( name ) as Command;
		}
		
		private function _executeCommand( event:Event ):void
		{	
		
			event.stopImmediatePropagation();
			if ( !isRegistered( event.type ) ) {
				Logger.error( this + " - can not execute Command with id " + event.type );
				return;
			}
			
			var cmmd:Command = super.locate( event.type ) as Command;			
			cmmd.execute ( event );			
		};
		
		
	
	}
}