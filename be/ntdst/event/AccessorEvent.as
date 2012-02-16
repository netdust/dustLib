package be.ntdst.event
{
	/**
	 * 
	 * ...
	 * @author Stefan Vandermeulen
	 * 
	 * 
	 * AccessorEvent.as
	 * 
	 * Use <code>AccessorEvent</code> to create an event that gives getter / setter access to it's target class. 
	 * This keeps the coupling between objects very loose since they don't need to know about each other or their api's.
	 * 
	 * @example
	 * 
	 * class someDispatchClass {
	 * 
	 * 	function id():* {
	 * 		return _val;
	 *  }
	 * 
	 * 	function setArticleData( v:*):void {
	 * 		_data = v;
	 *  }
	 *  
	 *  function fireEvent():void {
	 *  	dispatchEvent( new AccessorEvent( Event.GET_DATA, id, setArticleData )
	 *  }
	 * 
	 * }
	 * 
	 * class receiveEventClass {
	 * 
	 *  function handler( e:Event ):void {
	 * 		var data:XML = _getArticleDataById( AccessorEvent( e ).getValue() );
	 * 		AccessorEvent( e ).setValue( data );
	 *  }
	 * 
	 * }
	 */
	
	import be.ntdst.util.log.Logger;
	import flash.events.Event;
	 
	public 	class 	AccessorEvent 
			extends Event
	{
		protected var _sr:Function;
		protected var _gr:Function;
		
		public function AccessorEvent( _t:String, _getter:Function, _setter:Function ) 
		{
			super(_t, true, true );
			_gr = _getter;
			_sr = _setter;
		};
		
		public function getValue():* {
			return _gr();
		};
		
		public function setValue( v:*):void {
			_sr(v);
		};
		
		public override function clone():Event 
		{ 
			return new AccessorEvent(type, _gr, _sr );
		} 
		
		
	}
	
}