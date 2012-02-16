package be.ntdst.display 
{
	import flash.events.*
	import flash.display.*;
	
	public class ViewFactory 
	{
		
		public function ViewFactory() {
			
		}
		
		public static function createView( _cCll:Class, _sId:String = null, _sLib:String = null, register:Boolean = false ):View {	
			
			var _oVw:View;
			
			if( _sLib != null && _sLib != '' ) {
				var _oAst:Sprite = AssetLocator.getInstance().getAsset( _sId, _sLib );
				_oVw = new _cCll( _sId, _oAst );
			}
			else _oVw = new _cCll( _sId );
	
			if( _sId != null && register ) {
				ViewLocator.getInstance().register( _oVw.name, _oVw );
				ViewLocator.get(_sId).addEventListener( 
					Event.REMOVED_FROM_STAGE,
					unregister
				);
			}
			
			return _oVw;
		};
		
		private static function unregister(e:Event):void
		{			
			e.target.removeEventListener( Event.REMOVED_FROM_STAGE, unregister );
			ViewLocator.getInstance().unregister( View(e.target).name );
		};
		
	}
	
}