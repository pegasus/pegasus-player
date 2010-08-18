/*
	PureMVC Utility - Startup Manager
	Copyright (c) 2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/

package org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces
{
    /**
     *  The data property of AssetProxy.
     */
	public interface IAsset {

		function get url() :String;

		function get type() :String;

		function set data( obj :Object ) :void;

		function get data() :Object;

	}
}
