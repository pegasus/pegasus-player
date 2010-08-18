/*
	PureMVC Utility - Startup Manager - Manage loading of data resources at application startup
	Copyright (c) 2008-, collaborative, as follows
	2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/

package org.puremvc.as3.multicore.utilities.startupmanager.interfaces
{

    /**
     *  The retry parameters used by a retry policy must implement this interface.
     */
	public interface IRetryParameters {

        function get maxRetries() :int;

        function get retryInterval() :Number;

        function get timeout() :Number;

	}
}
