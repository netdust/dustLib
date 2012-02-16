package be.ntdst.display 
{
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.display.FrameLabel;
	
	/**
	* @author Stefan Vandermeulen - netdust.be
	*/
	public class 	EventMovieClip 
		   extends 	MovieClip
	{
		public static const onLabelEvent:String = "onLabelEvent";
		
		private var _movieclipInstance			:MovieClip;
		private var _labelMethods				:Object;
		
		override public function get currentLabel():String {
			return 	_movieclipInstance.currentLabel;
		};
		
		public function get instance():MovieClip {
			return 	_movieclipInstance;
		};
		
		public function EventMovieClip( emc:MovieClip ) {
			init( emc );
		};

		public function addMethodToLabel(label:String,func:Function):void
		{
			removeMethodFromLabel(label);
			_labelMethods[label] = func;
		};		
		
		public function removeMethodFromLabel(label:String):void { 
			_labelMethods[label] = null; 
		};
		
		public function register( l:Function ) : void {
			addEventListener( EventMovieClip.onLabelEvent, l, false, 0, true );
		};
		
		public function unregister( l:Function ) : void {
			removeEventListener( EventMovieClip.onLabelEvent, l );
		};

		private function init( emc:MovieClip ) : void {
			_labelMethods = {};
			_movieclipInstance = emc;
			var labels:Array = emc.currentLabels;

			for(var i:Number=0;i<labels.length;i++)	{
				var frameLabel:FrameLabel = labels[i];				
				emc.addFrameScript(frameLabel.frame-1,_onFrameLabel);
			};
		};
		
		private function _onFrameLabel() : void {			
			_movieclipInstance.stop();
			if (_labelMethods[_movieclipInstance.currentLabel] != null) {				
				_labelMethods[_movieclipInstance.currentLabel]();				
			};
			
			dispatchEvent(
				new Event(EventMovieClip.onLabelEvent)
			);
		};	
	
	}
	
}