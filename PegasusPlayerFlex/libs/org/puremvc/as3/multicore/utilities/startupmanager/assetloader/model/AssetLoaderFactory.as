/*
	PureMVC Utility - Startup Manager
	Copyright (c) 2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.startupmanager.assetloader.model
{
    import flash.net.URLRequest;
    import flash.system.LoaderContext;

    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces.IAssetLoader;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces.IAssetLoaderFactory;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces.IAssetTypeMap;

    /**
     *  
     */
	public class AssetLoaderFactory implements IAssetLoaderFactory
	{
        protected var assetTypeMap :IAssetTypeMap;

		public function AssetLoaderFactory( assetTypeMap :IAssetTypeMap ) {
		    this.assetTypeMap = assetTypeMap;
		}

		public function getAssetLoader( assetType :String, respondTo :AssetProxy ) :IAssetLoader {
		    var loaderClass :Class = assetTypeMap.getAssetLoaderClass( assetType );
		    var loader :IAssetLoader = new loaderClass( respondTo );

            // optional
            var loaderContext :LoaderContext = assetTypeMap.getLoaderContext( assetType );
            if ( loaderContext )
                loader.loaderContext = loaderContext;

            // optional
            var urlRequest :URLRequest = assetTypeMap.getURLRequest( assetType );
            if ( urlRequest )
                loader.urlRequest = urlRequest;

            return loader;
		}

	}
}