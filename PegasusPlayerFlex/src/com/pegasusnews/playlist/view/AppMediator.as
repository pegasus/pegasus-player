/*
* Created by: joel
* Created on: Jun 4, 2009
*/
package com.pegasusnews.playlist.view
{
	import com.pegasusnews.playlist.model.ConfigProxy;
	import com.pegasusnews.playlist.model.PlaylistProxy;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.startupmanager.model.StartupMonitorProxy;

	/**
	* TODO: Write a meaningful description of this Class.
	*/
	public class AppMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		
		public function AppMediator(viewComponent:PegasusPlaylistPlayer)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [StartupMonitorProxy.LOADING_COMPLETE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case StartupMonitorProxy.LOADING_COMPLETE: 
					var playlistProxy:PlaylistProxy = facade.retrieveProxy(PlaylistProxy.NAME) as PlaylistProxy;
					var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
					app.config = configProxy.config;
					app.playlist = playlistProxy.playlist;
					app.playItem(0);
					break;
				default : break;
			}
		}
		
		protected function get app():PegasusPlaylistPlayer
		{
			return this.viewComponent as PegasusPlaylistPlayer;
		}
	}
}