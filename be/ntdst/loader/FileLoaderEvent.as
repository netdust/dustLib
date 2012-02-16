package be.ntdst.loader
{
	
	import flash.events.Event;
	import be.ntdst.loader.strategy.*;
	
	public dynamic class FileLoaderEvent extends Event
	{
		
		public var error:String = '';
		public var content:Object = null;		
		public var loader:FileLoader = null;
		
		
		public function FileLoaderEvent( type:String, loader:FileLoader ) 
		{
			super(type, false, false);
			this.loader = loader;
		}
		
		override public function clone ():Event {
			return new FileLoaderEvent( type, loader );
		}

	}
	
}