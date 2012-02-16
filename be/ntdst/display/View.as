package be.ntdst.display 
{

	import be.ntdst.core.Abstract;

	import flash.display.*;
	import flash.events.*;

	
	/**
	 * ...
	 * @author Stefan Vandermeulen
	 */
	public 	class 	View 
			extends Sprite
	{
			
		private var _needredraw:Boolean;
		
		protected var _view:DisplayObjectContainer;
		public function get view():DisplayObjectContainer { return _view; }
		
		public function View( _sId:String = null, _Do:MovieClip = null ) 
		{
			Abstract.enforce(this, View);
			
			if ( _sId != null ) {
				name = _sId;			
			}
			if ( _Do == null ) _view = this;				
				else {
					_view = _Do;					
					var idx:int;
					var pr:Sprite;
					if( _view.parent != null ) {
						pr = Sprite( _view.parent );
						idx = pr.getChildIndex( _view );
					}
					addChildAt( _Do, 0 );
					if ( pr ) pr.addChildAt( this, idx );
				};
			
			view.addEventListener( Event.ADDED_TO_STAGE, _init );
			view.addEventListener( Event.REMOVED_FROM_STAGE, _dispose );
			
			if ( view.stage ) _init();
		};
		
		public function show ( ):void
		{
			view.visible = true;	
		};	
		
		public function hide ( ):void
		{
			view.visible = false;	
		};	
		
		public function draw ( ):void
		{
			_needredraw = false;
			dispatchEvent( 
				new Event( Event.RENDER ) 
			);
		};	
		
		public function move ( pX:Number, pY:Number ):void
		{
			view.x = pX;
			view.y = pY;	
		};
		
		public function size ( sW:Number, sH:Number ):void
		{
			view.width = sW;
			view.height = sH;		
			
			dispatchEvent( 
				new Event( Event.RESIZE ) 
			);
		};		
		
		public function resolveUI( _sId:String ):MovieClip
		{
			return view.getChildByName(_sId) as MovieClip
		};
		
		public function dispose( ):void
		{
			view.removeEventListener( Event.REMOVED_FROM_STAGE, _dispose );		
			view.removeEventListener( Event.ADDED_TO_STAGE, _init );
			
			if ( stage != null ) {
				stage.removeEventListener(Event.RENDER, _render );
				stage.addEventListener(Event.RESIZE, _resize );
			}
			
			while ( numChildren ) {
				removeChildAt( numChildren - 1 );
			};
			
			if ( view.parent != null ) {
				view.parent.removeChild( view )
			};
			
			_view = null;
		};
		
		public function notifyController( event:Event ):void {
			
			if ( !event.bubbles ) {
				event = new ErrorEvent( ErrorEvent.ERROR, true, true, 'event ( '+event+' ) could not reach controller' );
			};
			
			dispatchEvent( event );
			
		};
		
		protected function init( ):void
		{
			draw();
		};
		
		private function _init( event:Event = null ):void 
		{
			view.removeEventListener(Event.ADDED_TO_STAGE, _init);
			stage.addEventListener(Event.RENDER, _render, false, 0, true );
			stage.addEventListener(Event.RESIZE, _resize, false, 0, true );

			init( );
		}
		
		private function _resize(e:Event):void 
		{
			if (view!=null && view.stage!=null) {
				draw();
			}
		}
		
		private function _render(e:Event):void 
		{
			if (view!=null && view.stage!=null && _needredraw) {
				draw();
			}
		}
		
		private function _dispose(e:Event):void 
		{
			view.removeEventListener(Event.REMOVED_FROM_STAGE, _dispose);
			dispose();
		}

	}
	
}