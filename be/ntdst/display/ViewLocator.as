package be.ntdst.display 
{
	
	import be.ntdst.core.Locator;
	import be.ntdst.core.Singleton;
	
	public 	class 	ViewLocator 
			extends Locator
	{
		private static var _instance:ViewLocator;

		public static function getInstance():ViewLocator
		{
			if (ViewLocator._instance == null) {
				ViewLocator._instance = new ViewLocator( );
			}
			return ViewLocator._instance;
		};
		
		public static function put( _sId:String, _view:View ):Boolean 
		{
			return ViewLocator.getInstance().register( _sId, _view);  
		};
		
		public static function get( _sId:String ):View 
		{
			return ViewLocator.getInstance().locate( _sId ) as View;  
		};
		
		public function ViewLocator( ) 
		{
			Singleton.enforce( this );			
		};
		
	}
	
}
