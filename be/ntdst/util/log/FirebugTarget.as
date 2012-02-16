package be.ntdst.util.log 
{
	
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
    import flash.system.*;
    import flash.external.*;    
	

    public 	class 		FirebugTarget 
			implements 	LoggerTarget 
	{
        private static const levelMap:Object = { 	debug		:	"info"		, 
													info		:	"info"		, 
													warn		:	"warn"		, 
													error		:	"error"		, 
													critical	:	"error"
												};

        public function FirebugTarget(){
            super();
        };
		
        public function publish(level:String, path:String, obj:*):void {
			
			var log:Object = new Object();
			
			if ( (obj is String) ) {			
			log.message = obj;
            log.path = path;
            }
			else {
				log = obj;
			}

            if (!log){
                log = "null";
            };
			
			try {
				ExternalInterface.call("console." + levelMap[level], obj );
			}
			catch (e:Error) { 
					trace(path+" ["+ level.toUpperCase() + "] : " + obj);
				};

        }

    }
}
