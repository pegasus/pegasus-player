/*
	PureMVC Utility - Startup Manager
	Copyright (c) 2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.startupmanager.assetloader.controller
{
    import org.puremvc.as3.multicore.utilities.startupmanager.interfaces.IRetryParameters;

    /**
     *  LoadAssetGroupInstructions defines the instructions required by the
     *  LoadAssetGroupCommand, sent to it as the notification body.
     *  For the instructions to be sufficient, there must be a groupId and a groupOfUrls.
     *  <p>
     *  See StartupForAssets demo for an example use of this class.</p>
     */
	public class LoadAssetGroupInstructions {

        private var _groupId :String;
        private var _groupOfUrls :Array;
        private var _retryParameters :IRetryParameters;
        private var _progressReportInterval :Number;

		public function LoadAssetGroupInstructions( groupId :String, groupOfUrls :Array,
		    retryParameters :IRetryParameters =null, progressReportInterval :Number =NaN )
		{
		    this._groupId = groupId;
		    this._groupOfUrls = groupOfUrls;
		    this._retryParameters = retryParameters;
		    this._progressReportInterval = progressReportInterval;
		}
		public function get groupId() :String { return _groupId; }
		public function get groupOfUrls() :Array { return _groupOfUrls; }
		public function get retryParameters() :IRetryParameters { return _retryParameters; }
		public function get progressReportInterval() :Number { return _progressReportInterval; }

		public function isSufficient() :Boolean {
		    if ( groupId != "" && groupOfUrls.length > 0 )
		        return true;
		    else
		        return false;
		}
	}
}
