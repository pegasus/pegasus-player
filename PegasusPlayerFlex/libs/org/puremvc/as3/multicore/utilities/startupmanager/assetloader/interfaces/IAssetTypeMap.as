/*
	PureMVC Utility - Startup Manager
	Copyright (c) 2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/

package org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces
{
	import flash.system.LoaderContext;
	import flash.net.URLRequest;

	public interface IAssetTypeMap {

        function getAssetClass( assetType :String ) :Class;

        function getAssetLoaderClass( assetType :String ) :Class;

        function getLoaderContext( assetType :String ) :LoaderContext;

        function getURLRequest( assetType :String ) :URLRequest;

	}
}
