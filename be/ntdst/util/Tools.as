package be.ntdst.util 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	/**
	 * ...
	 * @author sv
	 */
	public class Tools 
	{
		
		public function Tools() 
		{
			
		}
		
		public static function linksToTextEvents(txt:String):String {
			var regExLink:RegExp = /<a[^>]+(http:\/\/[^"']+)['"][^>]*>([^<>]*)<\/a>/gi;
			var matched:String = txt.replace(regExLink, "<a href='event:$1'>$2</a>");
			return matched;
		}

		// mail
		public static function isValidEmail( value:String ):Boolean {
			return Boolean( value.match( /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{0,4}$/i ));
		}
		
		// Displayobject 
		public static function localToLocal(from:DisplayObject, to:DisplayObject, p:Point):Point {
			return to.globalToLocal(from.localToGlobal(p));
		};
		
		public static function clear(tgt:DisplayObjectContainer):void {
			while(tgt.numChildren)
				tgt.removeChildAt(tgt.numChildren - 1);			
		};
	
		public static function resizeInstance( tgt:DisplayObject, w:Number, h:Number ):void 
		{
			var ratio:Number = tgt.height / tgt.width;
			var width:Number = tgt.width;
			var height:Number = tgt.height;
			
			var _nwidth:Number = w;
		    var _nheight:Number = h;
			
			
			
			if ( !isNaN( ratio )  ) {
				
				if ( width > height ) {
					width = _nwidth;
					height = width * ratio;	
					if ( height > _nheight ) {
						height = _nheight;
						width = height / ratio;
					}
				}else {		
					height = _nheight;
					width = height * ratio;				
					if ( width > _nwidth ) {
						var perc:Number = (_nwidth / width) * 100;
						width =  _nwidth;
						height += height * (perc/100);
					}
				}
			}
			
			tgt.width = width;
			tgt.height = height;
		};
		
	}

}