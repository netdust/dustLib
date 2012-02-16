package be.ntdst.loader.strategy 
{
	
	import flash.net.*;
	import flash.events.*;
	import flash.system.*;
	
	import be.ntdst.core.*;
	import be.ntdst.loader.*;

	
	/**
	 * ...
	 * @author Stefan Vandermeulen
	 */
	final public class URLLoaderStrategy implements LoadStrategy
	{
		
		/**
		 * Specifies that downloaded data is received as raw binary data.
		 * 
		 */
		static public const BINARY : String = URLLoaderDataFormat.BINARY;
		
		/**
		 * Specifies that downloaded data is received as text.
		 * 
		 */
		static public const TEXT : String = URLLoaderDataFormat.TEXT;
		
		/**
		 * Specifies that downloaded data is received as URL-encoded variables.
		 * 
		 */
		static public const VARIABLES : String = URLLoaderDataFormat.VARIABLES;
		
		private var _loader:URLLoader;
		
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
			if(value == URLLoaderStrategy.TEXT || value == URLLoaderStrategy.BINARY || value == URLLoaderStrategy.VARIABLES)
				 _dataFormat = value;
			else _dataFormat = URLLoaderStrategy.TEXT;
		}
				
		public function URLLoaderStrategy( format:String = URLLoaderStrategy.TEXT ) 
		{
			dataFormat = format;
			_loader = new URLLoader();
		}
		
		public function load(path : URLRequest = null, loadingContext : LoaderContext = null) : void
		{
			_loader.addEventListener(Event.COMPLETE, _onComplete );
			_fileloader.dustLib::registerStrategyLoaderEvents( _loader );
			
			_loader.dataFormat = _dataFormat;
			
			_loader.load(path);
		}
		
		public function release() : void
		{
			_fileloader.dustLib::unRegisterStrategyLoaderEvents( _loader );
			
			if ( _loader )
			{
				try	{
					_loader.close();
				}
				catch( error : Error ){}
				
				_fileloader = null;
				_loader = null;
			}
		}
		
		public function toString():String {
			return 'URLLoaderStrategy ( ' + _dataFormat + ' )';
		}
		
		private function _onComplete(e:Event):void 
		{
			_loader.removeEventListener(Event.COMPLETE, _onComplete);
			_fileloader.content = _loader.data;
		}
		
	}

}