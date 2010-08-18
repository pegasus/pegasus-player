/*
* Created by: joel
* Created on: Jun 4, 2009
*/
package com.pegasusnews.playlist
{
	import com.pegasusnews.playlist.controller.ApplicationStartupCommand;
	import com.pegasusnews.playlist.model.ConfigProxy;
	import com.pegasusnews.playlist.model.PlaylistProxy;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.utilities.startupmanager.controller.StartupResourceFailedCommand;
	import org.puremvc.as3.multicore.utilities.startupmanager.controller.StartupResourceLoadedCommand;

	/**
	* TODO: Write a meaningful description of this Class.
	*/
	public class PlaylistPlayerFacade extends Facade
	{
		public static const STARTUP:String = "note/startup";
		
		public function PlaylistPlayerFacade(key:String)
		{
			super(key);
		}
        
        /**
         * Singleton shellFacade Factory Method
         */
        public static function getInstance( key:String ) : PlaylistPlayerFacade
        {
            if ( instanceMap[ key ] == null ) instanceMap[ key ] = new PlaylistPlayerFacade( key );
            return instanceMap[ key ] as PlaylistPlayerFacade;
        }
        
        /**
         * Register Commands with the Controller 
         */
        override protected function initializeController( ) : void 
        {
            super.initializeController();   
            registerCommand( STARTUP, ApplicationStartupCommand );
            this.registerResourceLoadedCommand(ConfigProxy.CONFIG_LOADED)
            this.registerResourceLoadedCommand(PlaylistProxy.PLAYLIST_LOADED);
            
            this.registerResourceFailedCommand(ConfigProxy.CONFIG_FAILED);
            this.registerResourceFailedCommand(PlaylistProxy.PLAYLIST_FAILED);
        }
         
        /**
         * Application startup
         * 
         * @param app a reference to the application component 
         */  
        public function startup( app:PegasusPlaylistPlayer ):void
        {
            sendNotification( STARTUP, app );


        }
        
        private function registerResourceLoadedCommand( notificationName :String ) :void {
            registerCommand( notificationName, StartupResourceLoadedCommand );
        }
        private function registerResourceFailedCommand( notificationName :String ) :void {
            registerCommand( notificationName, StartupResourceFailedCommand );
        }
	}
}