/*
	PureMVC Utility - Startup Manager - Manage loading of data resources at application startup
	Copyright (c) 2008-, collaborative, as follows
	2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/

package org.puremvc.as3.multicore.utilities.startupmanager.interfaces
{
    import org.puremvc.as3.multicore.utilities.startupmanager.model.StartupResourceProxy;

    /**
     *  The data property of StartupMonitorProxy.
     */
	public interface IResourceList {

		function addResource( r :Object ) :void;

		function addResources( rs :Array ) :void;

		function get length() :int;

		function getItemAt( i :int ) :Object;

		function contains( r :Object ) :Boolean;

		function isOkToClose() :Boolean;

		function close() :void;

		function forceClose() :void;

		function keepOpen() :void;

		function isOpen() :Boolean;

		function isClosed() :Boolean;

		function set expectedNumberOfResources( num :int ) :void;

		function get expectedNumberOfResources() :int;

        function get progressPercentage() :Number;

        function initialize() :void;

        function copy() :IResourceList;

        function getResourceViaStartupProxyName( proxyName :String ) :StartupResourceProxy;

		function getResources() :Array;

		/**
		 *    Do not use, use getResources() instead.  Retained for backward compatibility.
		 */
		function get resourceList() :Array;

	}
}
