package be.ntdst.core 
{
	import flash.events.ContextMenuEvent;
	import flash.net.*;		
	import flash.display.*;
	import flash.events.Event;	
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import be.ntdst.core.*;
	import be.ntdst.model.Settings;
	import be.ntdst.util.log.Logger;
	import be.ntdst.util.log.FirebugTarget;
	
	/**
	 * Document.as
	 * 
	 * This is the base class for an dustLib Application. Useally it is extended by the applications entry point
	 * and it will trigger some methods so setup is a breeze. The environment object passed to the constructor sets
	 * default settings and can be used to setup debug or for instance production modes.
	 * 
	 * This library tries to provides some singleton classes but none of the other classes depend on them. 
	 * As a developer you can choose when to use these classes, for instance the <code>viewLocator</code>
	 * 
	 */
	
	use namespace dustLib;	
	
	public class Document extends Sprite
	{

		/**
		 * Configuration object that will contain al settings for this application
		 * it also contains <code>config.initWidth</code> and <code>config.initHeight</code> 
		 * as the <code>config.stageWidth</code> and <code>config.stageHeight</code>
		 * 
		 * 
		 */
		protected var config:Settings;
		
		public function Document( environment:Object = null ) 
		{
			Abstract.enforce( this, Document );
			
			config = new Settings( 
					environment 
				);
			
			if (stage) dustLib::init();
			else addEventListener(Event.ADDED_TO_STAGE, dustLib::init);				
		}

		dustLib function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, dustLib::init);
			
			if ( !config.isRegistered( 'application' ) )
				config.application = 'dustLib Application';
				
			config.framework = 'dustLib Framework';
			config.version = '0.1';
			
			addEventListener(
				Event.ENTER_FRAME, 
				function( e:Event ):void {
					removeEventListener(Event.ENTER_FRAME, arguments.callee);
					dustLib::setup();	 
				} );

		}
		
		/*
		 * APPLICATION SETUP
		 ------------------------------------------------------*/
		 
		dustLib function setup():void 
		{
			dustLib::setupStage();
			dustLib::setupLogger();
			dustLib::setupContextMenu();
			
			_configuration(					
				function _buildApplication():void {											
					setupFrontController();							
					setupModels();
					setupViews();
				}				
			);
		}
		
		dustLib function setupStage():void {
			stage.addEventListener( Event.RENDER, stageListener );			
			stage.addEventListener( Event.RESIZE, stageListener );		
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.BEST;
			stage.frameRate = 60;
		}
		
		dustLib function setupLogger():void {
			Logger.info( 
				config.framework + " [v" + config.version + "]; "
				+ "application " + config.application 
			);
			
			Logger.target = new FirebugTarget();
			Logger.mode = Logger.DEBUG_MODE; 
		}
		
		dustLib function setupContextMenu() : void
		{
			var menuItem:ContextMenuItem = new ContextMenuItem( config.framework + " v" + config.version + "; netdust.be", false );
			menuItem.addEventListener( 
					ContextMenuEvent.MENU_ITEM_SELECT,
					function( e:Event ):void { navigateToURL( new URLRequest('http://netdust.be') ) } 
				);
			
			var menu : ContextMenu = new ContextMenu();
			menu.customItems.push( menuItem );
			menu.hideBuiltInItems();
			contextMenu = menu;
			
		}

		
		public function setupViews():void 
		{
			
		}
		
		public function setupModels():void 
		{
			
		}	
		
		public function setupFrontController():void 
		{
			
		}
		
		/*
		 * APPLICATION LISTENERERS
		 ------------------------------------------------------*/
		 
		protected function stageListener(e:Event):void 
		{
		
		}
		
		/*
		 * APPLICATION CONFIGURATION
		 ------------------------------------------------------*/
		
		protected function _configuration( completeHandler:Function ):void
        {
			var complete:Function = function( e:Event = null ):void {
			
				config.removeEventListener( Event.COMPLETE, arguments.callee );
				for ( var p:String in loaderInfo.parameters ) 
					config[p] = loaderInfo.parameters[p];
			
				Logger.mode = config.debug_mode; 
				
				config.width = _width;
				config.height = _height;
				config.initWidth = loaderInfo.width;
				config.initHeight = loaderInfo.height;

				completeHandler();
				
			};
			
			config.addEventListener( Event.COMPLETE, complete );
			
			if( config.isRegistered( 'configurationPath' ) ) {
				config.load( config.configurationPath );		
			}
			else complete();

        };	
		
		private function get _width():int 
		{
			return stage.stageWidth;
		}
		
		private function get _height():int 
		{
			return stage.stageHeight;
		}
		
	}

}