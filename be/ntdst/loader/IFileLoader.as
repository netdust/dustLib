package be.ntdst.loader
{	
	import be.ntdst.loader.strategy.LoadStrategy;
	import be.ntdst.command.Command;
	
	import flash.system.LoaderContext;
	import flash.net.URLRequest;

	public interface IFileLoader extends Command
	{
		function set name( value:String ):void
		function get name( ) : String
		
		function set priority(value:Number) : void
		function get priority() : Number	
		
		function set loadrequest(value:URLRequest) : void
		function get loadrequest() : URLRequest
		
		function set strategy(value:LoadStrategy) : void		
		function get strategy() : LoadStrategy		
		
		function set context(value:LoaderContext) : void
		function get context( ) : LoaderContext
		
		function set content(value:Object) : void
		function get content( ) : Object
		
		function get progress( ) : Number
		function get antiCache( ) : Boolean
		function get prefix( ) : String
		
		function removeAsListener( l:Function ):void
		function registerAsListener( l:Function ):void		
		
		function close():void
		function load( request:URLRequest = null ):void
		
	}
	
}