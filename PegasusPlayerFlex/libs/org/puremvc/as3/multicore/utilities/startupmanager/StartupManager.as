/*
	PureMVC Utility - Startup Manager - Manage loading of data resources at application startup
	Copyright (c) 2008-, collaborative, as follows
	2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.startupmanager
{
	/**
	*  The Startup Manager utility (SM) offers a solution to the problem of how to manage the 
	*  loading of data resources, be that at application startup or at some other time in the 
	*  duration of the application.  By resources, we mean data resources or resources that conform
	*  to the resource model adopted by SM.  This is the SM core facility, implemented by the 
	*  classes in the controller, interfaces and model packages.  These are independent of the
	*  assetloader package, which is an optional sub-system.  This core is based around the 
	*  StartupMonitorProxy class.  See that class for the primary documentation of the SM core.
	*  <p>
	*  The assetloader sub-system offers a solution to the loading of external assets, for example
	*  display assets.  It uses the SM core just as a client application would.  The general idea is
	*  <ul><li>
	*  there is a group of assets i.e. a set of urls</li>
	*  <li>the group is to be loaded as one job</li>
	*  <li>each url implies a particular asset type</li>
	*  <li>each asset type maps to a particular asset class and asset loader class</li>
	*  <li>each asset is fronted by an AssetProxy; this proxy implements the SM core interface 
	*  IStartupProxy and has the asset loader class in a delegate role</li>
	*  <li>the group of assets is fronted by an AssetGroupProxy.</li></ul>
	*  <p>
	*  One way to become familiar with this sub-system is as follows
	*  <ul><li>
	*  see the AssetTypeMap, AssetFactory and AssetLoaderFactory classes</li>
	*  <li>see the AssetGroupProxy and AssetProxy classes</li>
	*  <li>see the StartupForAssets demo, as an example use.</li>
	*  </ul></p>
	*/
	public class StartupManager {

        /**
         *  StartupManager core: Notifications to Client App
         */
		public static const LOADING_PROGRESS :String = "smLoadingProgress";
		public static const LOADING_COMPLETE :String = "smLoadingComplete";
		public static const LOADING_FINISHED_INCOMPLETE :String = "smLoadingFinishedIncomplete";
		public static const RETRYING_LOAD_RESOURCE :String = "smRetryingLoadResource";
		public static const LOAD_RESOURCE_TIMED_OUT :String = "smLoadResourceTimedOut";
		public static const CALL_OUT_OF_SYNC_IGNORED :String = "smCallOutOfSyncIgnored";
		public static const WAITING_FOR_MORE_RESOURCES :String = "smWaitingForMoreResources";

        /**
         *  StartupManager asset loader: Notifications to SM Core and available to Client App
         */
		public static const ASSET_LOADED :String = "smAssetLoaded";
		public static const ASSET_LOAD_FAILED :String = "smAssetLoadFailed";

        /**
         *  StartupManager asset loader: Notifications to Client App
         */
		public static const ASSET_GROUP_LOAD_PROGRESS :String = "smAssetGroupLoadProgress";
		public static const ASSET_LOAD_FAILED_IOERROR :String = "smAsetLoadFailedIOError";
		public static const ASSET_LOAD_FAILED_SECURITY :String = "smAsetLoadFailedSecurity";
		public static const NEW_ASSET_AVAILABLE :String = "smNewAssetAvailable";
		public static const URL_REFUSED_PROXY_NAME_ALREADY_EXISTS :String =
		    "smUrlRefusedProxyNameAlreadyExists";

        /**
         *  StartupManager asset loader: Asset Type constants
         */
        public static const IMAGE_ASSET_TYPE :String = "smImageAssetType";
        public static const TEXT_ASSET_TYPE :String = "smTextAssetType";
        public static const SWF_ASSET_TYPE :String = "smSwfAssetType";

	}

}
