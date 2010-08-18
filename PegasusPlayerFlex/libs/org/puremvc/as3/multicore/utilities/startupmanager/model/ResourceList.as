/*
	PureMVC Utility - Startup Manager - Manage loading of data resources at application startup
	Copyright (c) 2008-, collaborative, as follows
	2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.startupmanager.model
{
    import org.puremvc.as3.multicore.utilities.startupmanager.interfaces.IResourceList;

	/**
	*  This class holds the list of resources that StartupMonitorProxy manages as its data property.
	*  The list starts as open, so that resources can be added.  At some point it is closed, so that 
	*  no further resources can be added.
	*  
	*  The 'resources' are assumed to be StartupResourceProxy objects.
	*/
	public class ResourceList implements IResourceList {

        private static const OPEN :int = 1;
        private static const CLOSED :int = 2;

        protected var _resources :Array = new Array();
        protected var _status :int = OPEN;
        protected var _toBeKeptOpen :Boolean = false;
        protected var _expectedNumberOfResources :int = 0;

		public function ResourceList() {
		    initializeResourceList();
		}

		public function addResource( r :Object ) :void {
		    if ( _status == OPEN)
		        _resources.push(r);
		}
		public function addResources( rs :Array ) :void {
		    if ( _status == OPEN) {
    			for( var i:int = 0; i < rs.length; i++) {
    			    _resources.push( rs[i] );
    			}
		    }
		}
		public function get length() :int {
		    return _resources.length;
		}
		public function getItemAt( i :int ) :Object {
		    return _resources[i];
		}
		public function contains( r :Object ) :Boolean {
		    return _resources.indexOf( r ) >= 0
		}

		public function isOkToClose() :Boolean {
		    return _toBeKeptOpen ? false : true;
		}
		public function close() :void {
		    if ( isOkToClose () )
		        _status = CLOSED;
		}
		public function forceClose() :void {
		    _status = CLOSED;
		    _toBeKeptOpen = false;
		}

		public function keepOpen() :void {
		    if ( _status == OPEN )
		        _toBeKeptOpen = true;
		}
		public function isOpen() :Boolean {
		    return _status == OPEN;
		}
		public function isClosed() :Boolean {
		    return _status == CLOSED;
		}

		public function set expectedNumberOfResources( num :int ) :void {
	        _expectedNumberOfResources = num;
		}
		public function get expectedNumberOfResources() :int {
		    if ( isOpen() && _expectedNumberOfResources > _resources.length )
		        return _expectedNumberOfResources;
		    else
		        return _resources.length;
		}

        /**
         *  Override this method if a different calculation is required.
         */
        public function get progressPercentage() :Number {
            if ( expectedNumberOfResources > 0 )
                return ( numberOfLoadedResources() * 100 ) / expectedNumberOfResources;
            else
                return 0;
        }

        public function initialize() :void {
            initializeResourceList();
        }

        public function copy() :IResourceList {
            var rl :ResourceList = new ResourceList();
            rl._resources = this._resources.concat();
            rl._status = this._status;
            rl._toBeKeptOpen = this._toBeKeptOpen;
            rl._expectedNumberOfResources = this._expectedNumberOfResources;
            return rl;
        }

        /**
         *  In this resource list, find the StartupResourceProxy object, where the corresponding
         *  IStartupProxy object has the given name.  Return null if not found.
         */
        public function getResourceViaStartupProxyName( proxyName :String ) :StartupResourceProxy {
			for( var i:int = 0; i < _resources.length; i++) {
			    if ( ( _resources[i] as StartupResourceProxy ).appResourceProxyName() == proxyName )
			        return _resources[i] as StartupResourceProxy;
			}
            return null;
        }

        /**
         *  The resources array of this IResourceList; an array of StartupResourceProxy objects.
         *  This is safe, read-only access; as regards the array.
         */
		public function getResources() :Array {
		    return _resources.concat();
		}
		/**
		 *    Use getResources() instead, a more appropriate name.
		 */
		public function get resourceList() :Array {
		    return getResources();
		}

        protected function initializeResourceList() :void {
            _resources.length = 0;
            _status = OPEN;
            _toBeKeptOpen = false;
            _expectedNumberOfResources = 0;
        }

        protected function numberOfLoadedResources() :int {
            var count :int = 0;
			for( var i:int = 0; i < _resources.length; i++) {
			    if ( ( _resources[i] as StartupResourceProxy ).isLoaded())
			        count++;
			}
            return count;
        }

	}

}
