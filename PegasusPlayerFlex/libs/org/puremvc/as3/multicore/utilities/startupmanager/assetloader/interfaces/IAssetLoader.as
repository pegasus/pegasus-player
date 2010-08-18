/*
	PureMVC Utility - Startup Manager
	Copyright (c) 2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/

package org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces
{
	import flash.system.LoaderContext;
	import flash.net.URLRequest;

    /**
     *  
     */
	public interface IAssetLoader {

		function set loaderContext( context :LoaderContext ) :void;

		function get loaderContext() :LoaderContext;

		function set urlRequest( request :URLRequest ) :void;

		function get urlRequest() :URLRequest;

		function load( url :String ) :void;

	}
}
