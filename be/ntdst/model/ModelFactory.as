package be.ntdst.model 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Stefan Vandermeulen
	 */
	public class ModelFactory
	{
		
		public function ModelFactory() 
		{
			
		}
		
		public static function createModel( _cCll:Class, _sId:String = null, _oDt:* = null, register:Boolean = false ):Model {
			
			var _oMd:Model = new _cCll( _sId );
			if ( _oDt != null ) _oMd.data = _oDt;
			
			if ( _sId != '' && register ) {
				ModelLocator.getInstance().registerModel( _sId, _oMd );
				_oMd.addEventListener( 
					Model.DISPOSE,
					function( e:Event ):void {
						e.target.removeEventListener( e.type, arguments.callee );
						ModelLocator.getInstance().unregister( ( e.target as Model ).name );
					}
				);
			}

			return _oMd;

		}

	}

}