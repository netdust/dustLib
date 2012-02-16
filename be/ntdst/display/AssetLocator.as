package be.ntdst.display 
{
	
	import be.ntdst.loader.strategy.LoadStrategy;
	import flash.text.*;
	import flash.display.*;
	
	import be.ntdst.core.Locator;
	import be.ntdst.core.Singleton;
	
	public 	class 	AssetLocator 
			extends Locator
	{
		
		private static var _instance:AssetLocator;		
		public static const LIBRARY:String = "LIBRARY";
		
		public static function getInstance():AssetLocator
		{
			if (AssetLocator._instance == null) {
				AssetLocator._instance = new AssetLocator( );
			}
			return AssetLocator._instance;
		};
		
		public static function get( _sId:String ):LoadStrategy 
		{
			return AssetLocator._instance.locate( _sId ) as LoadStrategy;  
		};
		
		public function AssetLocator( ) {
			Singleton.enforce( this )
		};

		public function getAsset( _sId:String, _sLibId:String=LIBRARY ):Sprite 
		{
			if ( !isRegistered( _sLibId ) ) return null;
		
			var lib:LoadStrategy = locate( _sLibId ) as LoadStrategy;
			var c:Class = lib.getDefinition(_sId) as Class;  
			return new c as Sprite;  
			
		};
		
		public function getBitmap( _sId:String, _sLibId:String=LIBRARY ):BitmapData 
		{
			if ( !isRegistered( _sLibId ) ) return null;
		
			var lib:LoadStrategy = locate( _sLibId ) as LoadStrategy;
			var c:Class = lib.getDefinition(_sId) as Class;  
			return new c(0,0) as BitmapData;  
			
		};
		
		public function getFont( _sId:String, _sLibId:String=LIBRARY ):Font 
		{
			if ( !isRegistered( _sLibId ) ) return null;
			
			var lib:LoadStrategy = locate( _sLibId ) as LoadStrategy;
			var c:Class = lib.getDefinition(_sId) as Class;  
			return new c as Font;  
		};
		
	}
	
}