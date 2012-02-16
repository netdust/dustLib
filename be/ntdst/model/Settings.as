
package be.ntdst.model {
	

	import be.ntdst.util.log.Logger;
	import flash.net.*;
    import flash.utils.*;
	import flash.errors.*;
	import flash.events.*;


	public dynamic 	class 		Settings
					extends 	Proxy 
					implements  IEventDispatcher, ISettings
	{
	
		// ---------------------------------------------------------------------- //
		// Variables
		// ---------------------------------------------------------------------- //
		
		/**
		 * The dictionary used to map names to values, default values and
		 * validators.
		 */
		private var _sd:Dictionary;
			
		/**
		 * Shared object for storing local data.
		 */
		private var _so:SharedObject;
		
		/**
		 * EventDispatcher
		 */
		private var _oED:EventDispatcher = null;
		
		
		// ---------------------------------------------------------------------- //
		// Constructor
		// ---------------------------------------------------------------------- //
		
		/**
		 * Creates a new settings class with no registered settings.
		 * 
		 * @param values
		 *	Object containing default values for this objec.
		 */
		public function Settings( values:Object = null) {
			
			_sd = new Dictionary();
			_oED = new EventDispatcher(this);			
			
			if( values != null ) {
				parse( values );
				
				if (values.hasOwnProperty( 'sharedObjectName' ) && values.sharedObjectName != '' ) {
					_so = SharedObject.getLocal(values.sharedObjectName);
				}
			}
		}
		
		public function dispose():void {
			if (_sd) {
				for (var k:* in _sd) {
					SettingsNode(_sd[k]).dispose();
					delete _sd[k];
				}
			}
			_sd = null;
			_so = null;
		}
		
		public function load( url:String ):void {
			if ( url == null || url == "" ) {
				dispatchEvent( new Event( Event.COMPLETE ) );
				return;
			}
			
			var loader:URLLoader = new URLLoader( );				
			loader.addEventListener( Event.COMPLETE, function( e:Event ):void { 
				e.target.removeEventListener( Event.COMPLETE, arguments.callee );
				parse( new XML( e.target.data ) );
				dispatchEvent( new Event( Event.COMPLETE ) );
			} );
			loader.load( 
				new URLRequest( url )
			);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_oED.addEventListener( type, listener, useCapture, priority, useWeakReference );
		};

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_oED.removeEventListener( type, listener, useCapture );
		};

		public function dispatchEvent(event:flash.events.Event):Boolean {
			return _oED.dispatchEvent(event);
		};

		public function hasEventListener(type:String):Boolean {
			return _oED.hasEventListener(type);
		};

		public function willTrigger(type:String):Boolean {
			return _oED.willTrigger( type );
		};
		
		flash_proxy override function setProperty(name:*, value:*):void {  
			register(name, value );			
		}
		
		flash_proxy override function getProperty(prop:*):* { 	
			if (!isRegistered(prop)) {
				Logger.error("The requested setting '" + prop + "' is not registered.");
			}
			return validate(prop).currentValue;
		}
		
		public function parse( _settings:*, _override:Boolean = true ):void {	
			if (_settings==null) {
				return;
			}
			
			var parmaterList:XMLList = null;
			var parm:XML = null;
		
			switch( typeof( _settings ) )
			{
				case 'xml':
					parmaterList = XML(_settings).children();
					for each( parm in parmaterList ) {
						if ( !isRegistered( parm.name() ) || _override )
							register( parm.name(), 
								parm.hasComplexContent() 
									? parm 
									: parm.text() 
								);
					}
				break;
			default:
					parmaterList = describeType( _settings )..variable;					
					for each( parm in parmaterList ) {
						if ( !isRegistered( parm.@name ) || _override )
							register( parm.@name, _settings[parm.@name] );
					}
				break;
			}
			
			
		}
				
		public function isRegistered(name:String):Boolean {
			return (_sd[name] != null);
		}
		
		public function register(name:String, defaultValue:* = null, validator:Function = null, priority:uint = 20):void {
			var setting:SettingsNode = new SettingsNode(defaultValue, validator, priority);
			
			if (setting.validator != null) {
				setting.currentValue = setting.validator(defaultValue, setting.currentValue);
			} else {
				setting.currentValue = defaultValue;
			}
			
			_sd[name] = setting;
		}

		public function setSoSetting(name:String, value:*):void {
			if (_so) {
				_so.data[name] = value;
			}
		}
		
		public function getSoSetting(name:String, def:* = null):* {
			if (_so) {
				var result:* = _so.data[name];
				if (result) {
					return result;
				}
			}
			return def;
		}
		

		public function toString():String {
			var ret:String = "";
			for (var name:String in _sd) {
				ret += '\n - ' + name + ": " + SettingsNode(_sd[name]).currentValue;
			}
			return ret;
		}
		

		private function validate(name:String):SettingsNode {		
			return !SettingsNode( _sd[name] ) 
				? new SettingsNode( null, null, 20 )
				: _sd[name] ;
		}
	}
}

internal class SettingsNode 
{
	public var currentValue:*;
	public var defaultValue:*;
	public var validator:Function;
	public var priority:uint;
	public function SettingsNode(defaultValue:*, validator:Function, priority:uint)
	{
		
		this.currentValue = defaultValue;
		this.defaultValue = defaultValue;
		this.validator = validator;
		this.priority = priority;
	}
	public function dispose():void {
		currentValue = null;
		defaultValue = null;
		validator = null;
	}
}