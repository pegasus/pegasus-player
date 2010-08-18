/*
	PureMVC Utility - Startup Manager
	Copyright (c) 2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.startupmanager.assetloader.controller {
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import org.puremvc.as3.multicore.utilities.startupmanager.StartupManager;
	import org.puremvc.as3.multicore.utilities.startupmanager.model.StartupMonitorProxy;
	import org.puremvc.as3.multicore.utilities.startupmanager.model.RetryPolicy;
	import org.puremvc.as3.multicore.utilities.startupmanager.interfaces.IStartupProxy;
	import org.puremvc.as3.multicore.utilities.startupmanager.controller.StartupResourceLoadedCommand;
	import org.puremvc.as3.multicore.utilities.startupmanager.controller.StartupResourceFailedCommand;

    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.model.AssetGroupProxy;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.model.AssetProxy;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.model.AssetTypeMap;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.model.AssetFactory;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.model.AssetLoaderFactory;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces.IAsset;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces.IAssetTypeMap;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces.IAssetFactory;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces.IAssetLoaderFactory;

    /**
     *  This command provides a convenient way for a client app to use the StartupManager's asset 
     *  loader feature.  If it is not used, then the app must include an equivalent process.  See 
     *  the StartupForAssets demo for an example use of this command.  It is useful to think of
     *  the assetloader classes as being a client of the StartupManager core, even though they are
     *  contained within the utilty.
     *  <p>
     *  We choose to load this group of assets as a new use of the StartupManager (SM), 
     *  hence we have to reset() it since it might have been used already, say for a 
     *  different group of assets or whatever.  We use the groupId as the SM jobId for the
     *  duration of the loading process. 
     *  <p>
     *  Another approach might be to use the 'keep resource list open' feature and retain 
     *  the SM state across groups.</p>
     *  <p>
     *  Notification body is the loading instructions; it must be a LoadAssetGroupInstructions object.
     *  Instructions must include the group id and the group of urls as an array of url strings.
     *  Instructions can also include a specification of retry parameters, if the SM default is to
     *  be overriden - see StartupMonitorProxy. The retry parameters apply per asset.  The instructions
     *  can also specify a loading progress interval, to dictate the frequency of progress reporting, 
     *  if the default is to be overriden - see AssetGroupProxy.</p>
     *  <p>
     *  As regards retry parameters, note that the StartupAsOrdered demo offers interactive
     *  experience with them.</p>
     *  <p>
     *  We register each asset with the StartupManager (SM) using addResourceViaStartupProxy()
     *  - this is a nice shortcut but it requires that the SM will create the corresponding 
     *  StartupResourceProxy object internally and assumes that we don't need access to that 
     *  object, or at least we don't need easy access to it i.e. we don't have a local reference
     *  to it and we haven't specified its proxy name.</p>
     */
	public class LoadAssetGroupCommand extends SimpleCommand implements ICommand {

		protected const INSTRUCTIONS_NOT_SUFFICIENT_MSG :String =
		    "LoadAssetGroupCommand, instructions are not sufficient, cannot proceed";
		protected const PROXY_NAME_EXISTS_MSG :String =
            "LoadAssetGroupCommand, proxy name already exists, cannot proceed, name=";
		protected const STARTUP_MANAGER_BUSY_MSG :String =
            "LoadAssetGroupCommand, StartupManager is busy, cannot proceed";

		private var startupManager :StartupMonitorProxy;

        override public function execute( note :INotification ) : void {

            var instructions :LoadAssetGroupInstructions = note.getBody() as LoadAssetGroupInstructions;
            if ( ! instructions.isSufficient() )
                throw Error( INSTRUCTIONS_NOT_SUFFICIENT_MSG );

            if ( facade.hasProxy( instructions.groupId ))
                throw Error( PROXY_NAME_EXISTS_MSG + instructions.groupId );

            if ( ! facade.hasProxy( StartupMonitorProxy.NAME ))
                facade.registerProxy( new StartupMonitorProxy() );

            this.startupManager = facade.retrieveProxy( StartupMonitorProxy.NAME ) as StartupMonitorProxy;

            if ( startupManager.isOkToReset() ) {
                startupManager.reset();
                prepAssetGroupForLoad( instructions );
                startLoading();
            }
            else
                throw Error( STARTUP_MANAGER_BUSY_MSG );
        }

        protected function prepAssetGroupForLoad( instructions :LoadAssetGroupInstructions ) :void {

            // Make sure these 2 commands are registered for asset loading, 
            // even if it has already been done.
            facade.registerCommand( StartupManager.ASSET_LOADED, StartupResourceLoadedCommand );
            facade.registerCommand( StartupManager.ASSET_LOAD_FAILED, StartupResourceFailedCommand );

            var groupId :String = instructions.groupId;
            var groupOfUrls :Array = instructions.groupOfUrls;

            var assetTypeMap :IAssetTypeMap = new AssetTypeMap();
            var assetFactory :IAssetFactory = new AssetFactory( assetTypeMap );
            var assetLoaderFactory :IAssetLoaderFactory = new AssetLoaderFactory( assetTypeMap );

            var groupPx :AssetGroupProxy = new AssetGroupProxy( assetLoaderFactory, groupId );
            facade.registerProxy( groupPx );

            // possibly override default progress report interval
            if ( instructions.progressReportInterval )
                groupPx.progressReportInterval = instructions.progressReportInterval;

            // use this asset group id as the SM jobId, for this loading job 
            startupManager.jobId = groupId;

            // possibly override default SM retry policy
            if ( instructions.retryParameters )
                startupManager.defaultRetryPolicy = new RetryPolicy( instructions.retryParameters );

            // create an asset for each url and an asset proxy for each asset,
            // we use the url for the proxy name.
            for ( var i:int=0; i < groupOfUrls.length; i++ ) {
                var url :String = groupOfUrls[i];
                if ( facade.hasProxy( url )) {
                    sendNotification( StartupManager.URL_REFUSED_PROXY_NAME_ALREADY_EXISTS, url, groupId );
                }
                else {
                    var asset :IAsset = assetFactory.getAsset( url );
                    var px :IProxy = new AssetProxy( groupPx, url, asset );
                    facade.registerProxy( px );
                    groupPx.addAssetProxy ( px );
                    startupManager.addResourceViaStartupProxy( px as IStartupProxy );
                }
            }

        }
        protected function startLoading() :void {
            startupManager.loadResources();
        }

	}	
}
