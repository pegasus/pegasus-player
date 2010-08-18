/*
	PureMVC Utility - Startup Manager
	Copyright (c) 2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.startupmanager.assetloader.model.assets
{
    /**
     *  Abstract class.
     *  It is expected that subclasses will implement IAsset or IAssetForFlex.
     *  <p>
     *  See StartupManager class for introduction to the StartupManager Utility.</p>
     */
	public class AssetBase 
	{
        private var _url :String;
        private var _data :Object;

		public function AssetBase( url :String ) {
		    this._url = url;
		}
		public function get url() :String {
		    return _url as String;
		}
		public function set data( obj :Object ) :void {
		    _data = obj;
		}
		public function get data() :Object {
		    return _data;
		}

	}
}