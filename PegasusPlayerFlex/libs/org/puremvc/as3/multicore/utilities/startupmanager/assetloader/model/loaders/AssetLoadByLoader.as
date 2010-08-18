/*
	PureMVC Utility - Startup Manager
	Copyright (c) 2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.startupmanager.assetloader.model.loaders
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.IEventDispatcher;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.net.URLRequest;

    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces.IAssetLoader;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.model.AssetProxy;

	public class AssetLoadByLoader implements IAssetLoader
	{
        private var assetProxy :AssetProxy;
        private var loader :Loader;

        private var _loaderContext :LoaderContext;
        private var _urlRequest :URLRequest = new URLRequest();

		public function AssetLoadByLoader( respondTo :AssetProxy ) {
		    this.assetProxy = respondTo;
		}
		public function set loaderContext( context :LoaderContext ) :void {
		    this._loaderContext = context;
		}
		public function get loaderContext() :LoaderContext {
		    return this._loaderContext;
		}
		public function set urlRequest( request :URLRequest ) :void {
		    this._urlRequest = request;
		}
		public function get urlRequest() :URLRequest {
		    return this._urlRequest;
		}

        public function load( url :String ) :void {
            loader = new Loader();
            addListeners( loader.contentLoaderInfo );
            urlRequest.url = url;
            try {
                loader.load( urlRequest, loaderContext );
            } catch ( e :SecurityError ) {
                assetProxy.loadingSecurityError( "Error, id:" + e.errorID.toString() + ", msg:" + e.message );
            }
        }

        /**
         *  From experience, it seems that the SecurityErrorEvent is required, when loading swfs at least, 
         *  even though the Loader API does not specify it as an applicable Event.
         */
        protected function addListeners( dis :IEventDispatcher ) :void {
            dis.addEventListener( ProgressEvent.PROGRESS, progressHandler );
            dis.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
            dis.addEventListener( Event.INIT, initHandler );
            dis.addEventListener( Event.COMPLETE, completeHandler );
            dis.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
        }
        protected function progressHandler( ev :ProgressEvent ) :void {
            assetProxy.loadingProgress( ev.bytesLoaded, ev.bytesTotal );
        }
        protected function completeHandler( ev :Event ) :void {
            assetProxy.loadingComplete( loader.content );
            removeListeners( loader.contentLoaderInfo );
        }
        protected function ioErrorHandler( ev :Event ) :void {
            assetProxy.loadingIOError( ev.toString() );
            removeListeners( loader.contentLoaderInfo );
        }
        protected function securityErrorHandler( ev :Event ) :void {
            assetProxy.loadingSecurityError( ev.toString() );
            removeListeners( loader.contentLoaderInfo );
        }
        protected function initHandler( ev :Event ) :void {
            //ignored for now; override if required. 
        }

        protected function removeListeners( dis :IEventDispatcher ) :void {
            dis.removeEventListener( ProgressEvent.PROGRESS, progressHandler );
            dis.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
            dis.removeEventListener( Event.INIT, initHandler );
            dis.removeEventListener( Event.COMPLETE, completeHandler );
            dis.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
        }

	}
}