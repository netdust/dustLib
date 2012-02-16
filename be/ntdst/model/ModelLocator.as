package be.ntdst.model 
{
	
	import be.ntdst.core.*;
	
	/**
	 * ...
	 * @author Stefan Vandermeulen
	 */
	
	public 	class 	ModelLocator 
			extends Locator
	{
		private static var _instance:ModelLocator;

		public static function getInstance():ModelLocator
		{
			if (ModelLocator._instance == null) {
				ModelLocator._instance = new ModelLocator(  );
			}
			return ModelLocator._instance;
		};
		
		public static function get( _sId:String ):Model 
		{
			return ModelLocator.getInstance().locateModel( _sId );  
		};
		
		public function ModelLocator( ) {
			Singleton.enforce( this );
		};
		
		public function registerModel( name:String, model:Model ):Boolean {
			return super.register( name, model );
		}
		
		public function locateModel( name:String ):Model {
			return super.locate( name ) as Model;
		}
			
	}
	
}
