
package be.ntdst.util.log
{
    import flash.utils.*;    
    import flash.errors.*;
	
    public class Logger 
	{

        private static const LEVEL_ERROR:String = "error";       
        private static const LEVEL_WARN:String = "warn";
        private static const LEVEL_INFO:String = "info";        
        private static const LEVEL_DEBUG:String = "debug";
        private static const LEVEL_CRITICAL:String = "critical";

		public static const PRODUCTION_MODE:int = 1;
		public static const ALLERROR_MODE:int = 2;
		public static const DEBUG_MODE:int = 0;
		
		public static var target:LoggerTarget = new FirebugTarget();
        public static var mode:int = 0;
       
        public static function critical(obj:*):void{
            publish(LEVEL_CRITICAL, obj);
			throw Error(obj);
        };
		
        public static function debug(obj:*):void{
            publish(LEVEL_DEBUG, obj);
        };
		
        public static function error(obj:*):void{
            publish(LEVEL_ERROR, obj);
        };
		
        public static function warn(obj:*):void{
            publish(LEVEL_WARN, obj);
        };
		
        public static function info(obj:*):void{
            publish(LEVEL_INFO, obj);
        };
		
		private static function publish( LEVEL:String, obj:* ):void {
			
			if (mode == PRODUCTION_MODE){
                return;
            };
			if (mode == DEBUG_MODE && ( LEVEL != LEVEL_DEBUG && LEVEL != LEVEL_INFO )
			){
                return;
            };
            target.publish(LEVEL, '', obj);
		};

    }
}