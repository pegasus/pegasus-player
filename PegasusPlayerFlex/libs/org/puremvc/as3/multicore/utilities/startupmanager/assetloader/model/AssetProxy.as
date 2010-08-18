/*
	PureMVC Utility - Startup Manager
	Copyright (c) 2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.startupmanager.assetloader.model
{
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.utilities.startupmanager.interfaces.IStartupProxy;
	import org.puremvc.as3.multicore.utilities.startupmanager.controller.FailureInfo;

    import org.puremvc.as3.multicore.utilities.startupmanager.StartupManager;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces.IAssetLoader;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces.IAsset;

    /**
     *  This is a proxy class for an asset.  It contains an IASSET object.  It is created
     *  before the asset is loaded, and is involved in the loading.  It implements
     *  IStartupProxy so that the StartupManager can be used to manage the asset loading.
     *  <p>
     *  After loading is complete, this proxy remains as a repository of the IASSET object.</p>
     *  <p>
     *  It is intended that this proxy can act for a range of asset types, providing there is
     *  a suitable loader.  As key to understanding the approach, see AssetTypeMap, AssetFactory 
     *  and AssetLoaderFactory.</p>
     *  <p>
     *  The loader class, of type IAssetLoader, has a Delegate type role.  It works for this 
     *  AssetProxy class and reports back to it.</p>
     *  
     */
	public class AssetProxy extends Proxy implements IStartupProxy
	{
        protected var assetGroupProxy :AssetGroupProxy;
        protected var loader :IAssetLoader;

        protected var bytesLoaded :Number = 0;
        protected var bytesTotal :Number = 0;
        protected var loaded :Boolean = false;

        /**
         *  Contains the latest error message, if there is one. 
         */
        protected var loadingErrorMessage :String = "";

		public function AssetProxy( assetGroupProxy :AssetGroupProxy, proxyName :String, data :IAsset ) {
		    this.assetGroupProxy = assetGroupProxy;
			super( proxyName, data );
		}
		
		public function get url() :String {
		    return (data as IAsset).url;
		}
		public function get asset() :IAsset {
	        return data as IAsset;
		}
		public function set assetData( data :Object ) :void {
		    //( data as IAsset ).data = data;
		    asset.data = data;
		}
		public function getBytesLoaded() :Number {
		    return bytesLoaded;
		}
		public function getBytesTotal() :Number {
		    return bytesTotal;
		}
		public function isLoaded() :Boolean {
		    return loaded;
		}
		public function getLoadingErrorMessage() :String {
		    return loadingErrorMessage;
		}

        // assume only invoked by startup manager 
        public function load() :void {
            if (loaded) {
                // don't really expect this case
                sendNotification( StartupManager.ASSET_LOADED, getProxyName(), assetGroupProxy.getProxyName() );
            }
            else {
                this.loader = assetGroupProxy.getAssetLoaderFactory().getAssetLoader( asset.type, this );
                loader.load( url );
            }
        }

        /**
         *  The following suite of 'loading...' methods are callable from the loader object,
         *  based on loading events and outcomes.  They are not for public use otherwise.
         */

        /**
         *  Responds to feedback from the loader object.  Progress notifications are sent at
         *  the asset group level.
         */
        public function loadingProgress( bytesLoaded :Number, bytesTotal :Number ) :void {
            this.bytesLoaded = bytesLoaded;
            this.bytesTotal = bytesTotal;
            assetGroupProxy.loadingProgress( this );
        }
        /**
         *  Responds to feedback from the loader object, that loading is complete.
         *  Send ASSET_LOADED note, absolutely essential to the StartupManager.
         *  Send NEW_ASSET_AVAILABLE note, may be of interest to client app.
         *  Always include the notification type, to enable selection in client app.
         */
        public function loadingComplete( loadedData :Object ) :void {
            loaded = true;
            assetData = loadedData;
            loadingErrorMessage = "";
            sendNotification( StartupManager.ASSET_LOADED, getProxyName(), assetGroupProxy.getProxyName() );
            sendNotification( StartupManager.NEW_ASSET_AVAILABLE, asset, assetGroupProxy.getProxyName() );
            assetGroupProxy.loadingProgress( this, /* force report */ true );
        }
        /**
         *  Responds to feedback from the loader object, that io error has occurred.
         *  Send ASSET_LOAD_FAILED note, absolutely essential to the StartupManager.
         *  Send ASSET_LOAD_FAILED_IOERROR note, may be of interest to client app.
         *  Always include the notification type, to enable selection in client app.
         */
        public function loadingIOError( errMsg :String ) :void {
            loadingErrorMessage = errMsg;
            sendNotification( StartupManager.ASSET_LOAD_FAILED, getProxyName(), assetGroupProxy.getProxyName() );
            sendNotification( StartupManager.ASSET_LOAD_FAILED_IOERROR, this, assetGroupProxy.getProxyName() );
        }
        /**
         *  Responds to feedback from the loader object, that security error has occurred.
         *  Send ASSET_LOAD_FAILED note, absolutely essential to the StartupManager.  With this
         *  kind or error, tell the SM not to bother with retry.
         *  Send ASSET_LOAD_FAILED_SECURITY note, may be of interest to client app.
         *  Always include the notification type, to enable selection in client app.
         */
        public function loadingSecurityError( errMsg :String ) :void {
            loadingErrorMessage = errMsg;
            var infoToStartupManager :FailureInfo = new FailureInfo( getProxyName(), /* allowRetry=NO*/ false);
            sendNotification( StartupManager.ASSET_LOAD_FAILED, infoToStartupManager, assetGroupProxy.getProxyName() );
            sendNotification( StartupManager.ASSET_LOAD_FAILED_SECURITY, this, assetGroupProxy.getProxyName() );
        }

	}
}