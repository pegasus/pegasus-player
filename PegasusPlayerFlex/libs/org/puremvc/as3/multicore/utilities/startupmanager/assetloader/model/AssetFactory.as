/*
	PureMVC Utility - Startup Manager
	Copyright (c) 2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.startupmanager.assetloader.model
{
    import org.puremvc.as3.multicore.utilities.startupmanager.StartupManager;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces.IAsset;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces.IAssetFactory;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces.IAssetTypeMap;

    /**
     *  
     */
	public class AssetFactory implements IAssetFactory
	{
		protected const UNEXPECTED_URL_TYPE_MSG :String =
		    ": AssetFactory, urlToType(), unexpected url type";

        protected var assetTypeMap :IAssetTypeMap;

		public function AssetFactory( assetTypeMap :IAssetTypeMap ) {
		    this.assetTypeMap = assetTypeMap;
		}
		//----------------------------------------------------------------------------

		public function getAsset( url :String, type :String = null ) :IAsset {
		    var assetType :String = type;
		    if ( ! assetType )
		        assetType = urlToType( url );
		    var assetClass :Class = assetTypeMap.getAssetClass( assetType );
		    return new assetClass( url );
		}

        //-----------------------------------------------------------------------------

		protected function urlToType( url :String ) :String {
		    var urllo :String = url.toLowerCase();
		    if ( endsWithAnyOf( urllo, [".jpg", ".gif", ".png"] ) ) return StartupManager.IMAGE_ASSET_TYPE;

		    else if ( endsWithAnyOf( urllo, [".txt", ".xml"] ) ) return StartupManager.TEXT_ASSET_TYPE;

		    else if ( endsWithAnyOf( urllo, [".swf"] ) ) return StartupManager.SWF_ASSET_TYPE;

            else throw Error( url + UNEXPECTED_URL_TYPE_MSG );
		}

		protected function endsWithAnyOf( url :String , endings :Array ) :Boolean {
		    var ulen : int = url.length;
		    var ix :int;
		    for (var i:int=0; i < endings.length; i++ ) {
		        ix = url.lastIndexOf( endings[i] );
		        if ( ix >= 0 && ( ix == ulen - endings[i].length ) )
		            return true;
		    }
		    return false;
		}

	}
}