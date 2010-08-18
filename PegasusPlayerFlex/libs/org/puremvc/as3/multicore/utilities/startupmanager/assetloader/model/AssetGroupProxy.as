/*
	PureMVC Utility - Startup Manager
	Copyright (c) 2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.startupmanager.assetloader.model
{
	//import flash.display.Loader;

	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

    import org.puremvc.as3.multicore.utilities.startupmanager.StartupManager;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces.IAsset;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces.IAssetLoaderFactory;

    /**
     *  This is a proxy class for a group of assets.  It contains a list of AssetProxy objects,
     *  one for each asset.  It is mainly concerned with the loading of those assets.  Loading is
     *  carried out by the StartupManager (SM), using this proxy's proxyName as the jobId.
     *  <p>
     *  After loading is complete, this proxy remains as a repository of the AssetProxy objects
     *  and hence of the assets themselves.</p>
     *  <p>
     *  As key to understanding AssetGroupProxy and AssetProxy, first see AssetTypeMap, 
     *  AssetFactory and AssetLoaderFactory.</p>
     *  <p>
     *  Loading progress reporting is managed here, being the progress of the group of assets. The
     *  approach adopted ignores the SM progress reporting.  The standard SM progress reporting is
     *  simply based on number of assets loaded.  We want to take account of asset size.</p>
     *  <p>
     *  An alternative that would integrate with SM progress notification could be as follows
     *  <ul>
     *  <li>extend ResourceList and override get progressPercentage so as to use AssetGroupProxy and
     *  AssetProxy information and thus calculate the percentage in a manner equivalent to the
     *  approach used here</li>
     *  <li>inject this custom ResourceList into the StartupMonitorProxy constructor; creating and
     *  registering a new StartupMonitorProxy should not be a problem, providing there is not one
     *  currently active</li>
     *  <li>invoke the StartupManager sendProgressNotification() method each time a progress report
     *  is required.</li>
     *  </ul></p>
     *  <p>
     *  The approach adopted here is considered simpler than the above alternative.</p>
     *  
     */
	public class AssetGroupProxy extends Proxy
	{
        protected var assetLoaderFactory :IAssetLoaderFactory;
        protected var _progressReportInterval :Number = 0.5; //secs, = 500 msecs.
        protected var timeOfLastProgressReport :Date = new Date();

		public function AssetGroupProxy( factory :IAssetLoaderFactory, proxyName :String ) {
			this.assetLoaderFactory = factory;
			super( proxyName, new Array() );
		}
		public function getAssetLoaderFactory() :IAssetLoaderFactory {
		    return assetLoaderFactory;
		}
		public function addAssetProxy( px :IProxy ) :void {
		    assetProxies.push( px );
		}

		public function set progressReportInterval( interval :Number ) :void {
		    _progressReportInterval = interval;
		}
		public function get progressReportInterval() :Number {
		    return _progressReportInterval;
		}

		public function isLoaded() :Boolean {
            var assetPx :AssetProxy;
            for (var i:int=0; i < assetProxies.length; i++) {
                assetPx = assetProxies[ i ] as AssetProxy;
                if ( ! assetPx.isLoaded() )
                    return false;
            }
            return true;
        }
		public function getAsset( url :String ) :IAsset {
		    var assetPx :AssetProxy;
		    for (var i:int=0; i < assetProxies.length; i++) {
		        assetPx = assetProxies[i] as AssetProxy;
		        if ( assetPx && ( assetPx.url == url ))
		            return assetPx.asset;
		    }
		    return null;
		}

        /**
         *  Re the calculation of percent loaded for the asset group
         *  - a count of number loaded, as one of the inputs, proved of little value, since the 
         *  loading complete event can occur a relatively long time after the bytes have been loaded.
         *  
         */
        public function loadingProgress( assetPx :AssetProxy, forceReport :Boolean = false ) :void {
            if ( forceReport || progressReportIsDue() ) {
                timeOfLastProgressReport = new Date();
                var percentLoaded :Number;
                 if ( allAssetProxiesHaveBytesTotal() ) {
                    percentLoaded =  ( calcOverallBytesLoaded() *100 ) / calcOverallBytesTotal() ;
                }
                else {
                    // rough estimate, ignores relative asset sizes
                    percentLoaded = ( sumOfAssetPercentsLoaded() / assetProxies.length );
                }
                sendNotification( StartupManager.ASSET_GROUP_LOAD_PROGRESS, percentLoaded, getProxyName() );
            }
        }


        public function allAssetProxiesHaveBytesTotal() :Boolean {
            for (var i:int=0; i < assetProxies.length; i++) {
                if (( assetProxies[i] as AssetProxy ).getBytesTotal() == 0 )
                    return false;
            }
            return true;
        }
        public function calcOverallBytesTotal() :Number {
            var total :int =0;
            for (var i:int=0; i < assetProxies.length; i++) {
                total += ( assetProxies[i] as AssetProxy ).getBytesTotal();
            }
            return total;
        }
        /**
         *  For an asset with bytesTotal of zero, ignore any bytesLoaded value.
         */
        public function calcOverallBytesLoaded() :Number {
            var total :int =0;
            var assetPx :AssetProxy;
            for (var i:int=0; i < assetProxies.length; i++) {
                assetPx = assetProxies[ i ] as AssetProxy;
                if ( assetPx.getBytesTotal() > 0 )
                    total += assetPx.getBytesLoaded();
            }
            return total;
        }
        public function sumOfAssetPercentsLoaded() :Number {
            var sum :Number =0;
            var assetPx :AssetProxy;
            for (var i:int=0; i < assetProxies.length; i++) {
                assetPx = assetProxies[ i ] as AssetProxy;
                if ( assetPx.isLoaded() )
                    sum += 100;
                else if ( assetPx.getBytesTotal() > 0 )
                    sum +=  ( assetPx.getBytesLoaded() *100 ) / assetPx.getBytesTotal();
            }
            return sum;
        }

        //--------------------------------------------------------------------
		protected function get assetProxies() :Array {
		    return data as Array;
		}

        protected function progressReportIsDue() :Boolean {
            var timeNow :Date = new Date();
            if ( timeNow.time >= ( timeOfLastProgressReport.time + progressReportInterval*1000 ))
                return true;
            else
                return false;
        }

	}
}