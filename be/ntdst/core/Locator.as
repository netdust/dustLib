package be.ntdst.core 
{
	
	/**
	 * Locator.as
	 * 
	 * Abstract <code>Locator</code> class to help building locators.
	 * 
	 * @example The following code is an example of a basic Locator class:
     *  if( viewLocator.isRegistered( 'view_id' ) ) 
	 * 		var view:View = viewLocator.get( 'view_id' );
	 * 
	 * 
	 */
	
	import be.ntdst.util.log.Logger;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class Locator extends EventDispatcher
	{
		protected var _m:Dictionary;
		
		/** 
		 * Boolean that indicates that an instance is registered with the locator
		 * 
		 * @param String instance id
		 */
		public function isRegistered( name : String ) : Boolean
		{
			return ( _m[ name ] != null );
		};

		/**
		 * Register an instance with this locator. You can use the id to retrieve the instance later on.
		 * 
		 * @param	name String instance id
		 * @param	o * instance to register
		 * @return Boolean default false
		 */
		protected function register( name : String, o : * ) : Boolean
		{
			if ( !isRegistered( name ) )
			{
				_m[ name ] = o;
				return true;
			} 
			
			Logger.error( this +" - allready contains instance with id " + name  );
			return false;
		};

		/**
		 * Unregister an instance from the locator
		 * 
		 * @param	name String instance id
		 * @return Boolean default false
		 */
		public function unregister( name : String ) : Boolean
		{
			if ( isRegistered( name ) )
			{
				delete _m[ name ];
				return true;
			} 
			
			Logger.error( this +" - can not unregister instance with id " + name  );
			return false;
		};

		/**
		 * Find an instance with id 'name' that is registered with this locator.
		 * If no instance is found, return object is null
		 * 
		 * @param	name String instance id
		 * @return Boolean default null
		 */
		protected function locate( name : String ) : *
		{
			if ( isRegistered( name ) ) 
			{
				return _m[ name ];
			} 
			
			return null;
		};

		/**
		 * release the locator, no instance are registered after calling this method
		 * 
		 */
		public function release() : void
		{
			_m = new Dictionary( true );
		};
		
		public function Locator() 
		{
			Abstract.enforce( this, Locator );
			release();
		};
		
		public override function toString():String {
			return "Locator";
		};
	}
	
}