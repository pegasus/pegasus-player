/*
	PureMVC Utility - Startup Manager - Manage loading of data resources at application startup
	Copyright (c) 2008-, collaborative, as follows
	2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.startupmanager.controller
{
    /**
     *  FailureInfo can be used as the Notification body when a resource load fails.
     *  See InvoiceProxy class in StartupAsOrdered demo for an example use of this class.
     */
	public class FailureInfo {

        private var _proxyName :String;
        private var _allowRetry :Boolean;

		public function FailureInfo( proxyName :String, allowRetry :Boolean =true ) {
		    this._proxyName = proxyName;
		    this._allowRetry = allowRetry;
		}
		public function get proxyName() :String { return _proxyName; }
		public function get allowRetry() :Boolean { return _allowRetry; }
	}
}
