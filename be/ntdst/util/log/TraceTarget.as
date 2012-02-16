
package be.ntdst.util.log {

    public 	class 		TraceTarget 
			implements  LoggerTarget 
	{

        public function TraceTarget(){
            super();
        };
		
        public function publish(level:String, path:String, obj:*):void {
			if( obj is String ) {
				trace( "[" + level.toUpperCase() + "] " + path + " :: " + obj );
			else {
				try {
					trace( "[" + level.toUpperCase() + "] " + path + " :: Object" );
					trace( deepTrace( obj ) );
				} catch ( e:Error ) {
					trace( "[" + level.toUpperCase() + "] " + path + " ::" + obj );
				}
			}
        };
		
		private function deepTrace( obj:* , level:int = 0, str:String = '' ):String {
			var tabs : String = "";
			for ( var i : int = 0 ; i < level ; i++, tabs += "\t" );			
			for ( var prop : String in obj ){				 
				str += deepTrace(
					obj[ prop ], 
					level + 1, 
					(str!=''? '\n':'') + ( tabs + "[" + prop + "] -> " + obj[ prop ] )
				);
			}			
			return str;
		};

    }
}
