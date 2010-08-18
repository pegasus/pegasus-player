/*
* Created by: joel
* Created on: Jun 4, 2009
*/
package com.pegasusnews.playlist.controller
{
	import com.pegasusnews.playlist.model.ConfigProxy;
	import com.pegasusnews.playlist.model.PlaylistProxy;
	import com.pegasusnews.playlist.view.AppMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.utilities.startupmanager.interfaces.IStartupProxy;
	import org.puremvc.as3.multicore.utilities.startupmanager.model.RetryParameters;
	import org.puremvc.as3.multicore.utilities.startupmanager.model.RetryPolicy;
	import org.puremvc.as3.multicore.utilities.startupmanager.model.StartupMonitorProxy;
	import org.puremvc.as3.multicore.utilities.startupmanager.model.StartupResourceProxy;

	/**
	* TODO: Write a meaningful description of this Class.
	*/
	public class ApplicationStartupCommand extends SimpleCommand implements ICommand
	{
		private var monitor:StartupMonitorProxy;
		
		override public function execute(notification:INotification):void
		{
			var app:PegasusPlaylistPlayer = notification.getBody() as PegasusPlaylistPlayer;
			facade.registerMediator(new AppMediator(app));
			
			var retryParameters:RetryParameters = new RetryParameters(5,5,5);
			var retryPolicy:RetryPolicy = new RetryPolicy(retryParameters)
			var monitorProxy:StartupMonitorProxy = new StartupMonitorProxy();
			monitorProxy.defaultRetryPolicy = retryPolicy;
            facade.registerProxy( monitorProxy );
            this.monitor = facade.retrieveProxy( StartupMonitorProxy.NAME ) as StartupMonitorProxy;
            
            var configProxy:IStartupProxy = new ConfigProxy();
            var playlistProxy:IStartupProxy = new PlaylistProxy();
            
            facade.registerProxy(configProxy);
            facade.registerProxy(playlistProxy);
            
            var rConfig:StartupResourceProxy = this.makeAndRegisterStartupResource(ConfigProxy.SRNAME,configProxy)
            var rPlaylist:StartupResourceProxy = this.makeAndRegisterStartupResource(PlaylistProxy.SRNAME,playlistProxy);
            
            rPlaylist.requires = [rConfig]
            
            monitor.loadResources();
		}
        
        private function makeAndRegisterStartupResource( proxyName :String, appResourceProxy :IStartupProxy ):StartupResourceProxy
        {
            var r :StartupResourceProxy = new StartupResourceProxy( proxyName, appResourceProxy );
            facade.registerProxy( r );
            monitor.addResource( r );
            return r;
        }
	}
}