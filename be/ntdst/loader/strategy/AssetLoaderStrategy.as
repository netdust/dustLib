package be.ntdst.loader.strategy 
{
	
	import flash.events.*;
	import flash.display.*;
	import flash.net.*;
	import flash.system.*;
	
	import be.ntdst.core.dustLib;
	import be.ntdst.loader.FileLoader;
	
	
	/**
	 * ...
	 * @author Stefan Vandermeulen - netdust.be
	 */
	public class AssetLoaderStrategy implements LoadStrategy
	{
		
		/**
		 * Specifies that downloaded data is received as raw binary data.
		 * 
		 */
		static public const SWF : String = 'swf';
		
		/**
		 * Specifies that downloaded data is received as raw binary data.
		 * 
		 */
		static public const JPG : String = 'jpg';
		
		/**
		 * Specifies that downloaded data is received as raw binary data.
		 * 
		 */
		static public const FONT : String = 'font';
		
		private var _loader:Loader;
		
		/**
		 * strategies parent object
		 * 
		 * @param value:FileLoader fileloader that wrappes this strategy
		 */
		private var _fileloader:FileLoader;
		public function set fileloader(value : FileLoader) : void
		{
			_fileloader = value;
		}
		
		/**
		 * format from returned data
		 * 
		 * @param value:String 
		 */
		private var _dataFormat : String;
		public function get dataFormat( ):String { return _dataFormat };
		public function set dataFormat(value : String) : void
		{
			if(value == AssetLoaderStrategy.SWF || value == AssetLoaderStrategy.JPG || value == AssetLoaderStrategy.FONT)
				 _dataFormat = value;
			else _dataFormat = AssetLoaderStrategy.SWF;
		}
		
		public function AssetLoaderStrategy( format:String = AssetLoaderStrategy.SWF ) 
		{
			_loader = new Loader();
			_dataFormat = format;
		}
		
		public function load(path : URLRequest = null, loadingContext : LoaderContext = null) : void
		{
			_loader.contentLoaderInfo.addEventListener(	Event.COMPLETE, _onComplete	);
			_fileloader.dustLib::registerStrategyLoaderEvents( _loader.contentLoaderInfo );
			
			_loader.load(path);
		}
		
		public function release() : void
		{
			
	
			if ( _loader )
			{
				
				try	{
					_fileloader.dustLib::unRegisterStrategyLoaderEvents( _loader.contentLoaderInfo );
					_loader.close();
				}
				catch( error : Error ){}
				
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _onComplete);
				_fileloader = null;
				_loader = null;
			}
		}
		
		public function toString():String {
			return 'AssetLoaderStrategy ( ' + _dataFormat + ' )';
		}
		
		private function _onComplete(e:Event):void 
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _onComplete);
			_fileloader.content = _loader.content;
		}
		
	}

}