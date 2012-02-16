package be.ntdst.model 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;


	public class Model extends EventDispatcher
	{
		public static const INIT:String = "init";
		public static const DISPOSE:String = "dispose";
		
		private var _data:*;		
		public function set data(m:*):void {
			_data = m;
			dispatchEvent( new Event( INIT ) );
		};
		
		public function get data():* {
			return _data;
		};
		
		private var _sName:String;
		public function get name():String {
			return _sName;
		};
		
		public function Model( _sId:String = '' ) 
		{
			_sName = _sId;		
		};
		
		public function find( key:* ):* {
			return null;
		}
		
		public function load( ):void {
			
		}
		
		public function registerAsListener( event:Class, listener:Function ):void {
			var list:XMLList = describeType( event ).constant;
			for each( var constant:XML in list ) {
				addEventListener( event[constant.@name], listener, false, 0, true );
			}
		};
		
		public function unregisterAsListener( event:Class, listener:Function ):void {
			var list:XMLList = describeType( event ).constant;
			for each( var constant:XML in list ) {
				removeEventListener( event[constant.@name], listener );
			}
		};

		public function dispose():void {
			_sName = '';
			_data = null;			
			dispatchEvent( new Event( DISPOSE ) );
		};
	}
	
}