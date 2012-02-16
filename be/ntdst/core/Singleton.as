package be.ntdst.core 
{

	/**
	 * Singleton.as
	 * 
	 * Use <code>Singleton</code> to create an singleton class. If this class is initiated from its constructor
	 * an IllegalOperationError is thrown. This forces developers to initiate it using getInstance()
	 * 
	 * @example
	 * 
	 * pacakage {
	 * 
	 * 		public static function getInstance():someSingleton {
	 * 			if (someSingleton._instance == null) {
	 *				someSingleton._instance = new someSingleton( );
	 *			}
	 *			return someSingleton._instance;
	 * 		}
	 * 
	 * 		function someSingleton() {
	 * 			Singleton.enforce( this )	
	 * 		}
	 * 
	 * }
	 * 
	 * var instance:someSingleton = someSingleton.getInstance();
	 * 
	 * 
	 */
	
	import flash.errors.IllegalOperationError;
	import flash.system.Capabilities;
	import flash.display.Loader;
	import flash.utils.*;	
	import flash.net.*;	
	

	public class Singleton 
	{
		private static const singletons : Dictionary = new Dictionary(true);
		private static const exception : String = "Singleton exception. Instance must be instantiated using getInstance()";
		
		public static function enforce(instance:*) : void
        {
			var className:String = getQualifiedClassName( instance );		
			if( singletons[ className ] ) {
				throw new IllegalOperationError(exception);
			};			
			singletons[ className ] = true;		
        }

	}
}