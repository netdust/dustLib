package be.ntdst.loader.strategy 
{
	import be.ntdst.loader.FileLoader;
	import flash.net.*;
	import flash.system.*;
	
	/**
	 * ...
	 * @author Stefan Vandermeulen
	 */
	public interface LoadStrategy 
	{
		
		/**
		 * Returns the url request data format
		 * 
		 */
		function set dataFormat( value:String ):void 
		function get dataFormat( ):String 
		
		/**
		 * The FileLoader of this strategy.
		 * 
		 */
		function set fileloader(value : FileLoader) : void;
		
		/**
		 * Loads content.
		 * 
		 * @param	loadingRequest	The absolute or relative URL of the content to load.
		 * @param	loadingContext	(optional) A LoaderContext object 
		 * 
		 */
		function load(path : URLRequest = null, loadingContext : LoaderContext = null) : void;

		/**
		 * Releases loading process.
		 * 
		 */
		function release() : void;
	}
	
}