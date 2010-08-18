/*
	PureMVC Utility - Startup Manager - Manage loading of data resources at application startup
	Copyright (c) 2007-2008, collaborative, as follows
	2007 Daniele Ugoletti, Joel Caballero
	2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.startupmanager.model
{
    import flash.utils.Timer;
    import flash.events.TimerEvent;

	import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    import org.puremvc.as3.multicore.utilities.startupmanager.interfaces.IStartupProxy;
    import org.puremvc.as3.multicore.utilities.startupmanager.interfaces.IRetryPolicy;

	/**
	*  See the <code>StartupMonitorProxy</code> class for the primary documentation on the
	*  Startup Manager utility.  See the demo app called StartupAsOrdered as an example of
	*  how <code>StartupResourceProxy</code> can be used.  In particular, see LoadResourcesCommand in
	*  that app.
	*  <p>
	*  It is assumed that the client application has a puremvc-compliant proxy object for each
	*  startup resource, each uniquely named. Those objects must implement <code>IStartupProxy</code>.</p>
	*  <p>
	*  In addition, the app must instantiate a <code>StartupResourceProxy</code> object for
	*  each startup resource, with a reference to the IStartupProxy object being passed to 
	*  the constructor.  These <code>StartupResourceProxy</code> objects exist only for the purposes of
	*  the utility.  How they are named is of no interest to the utility.  The utility does not require that
	*  they are registered with the puremvc model i.e. facade.registerProxy.  It is a matter for the
	*  app whether it wishes to retrieve one of these objects by name, to access state information.</p>
	*  <p>
	*  To specify dependencies between resources, use the <code>requires</code> property.  For example,
	*  if we have 3 resources <code>r1,r2,r3</code>, and r3 requires that r1 and r2 must be loaded first,
	*  then we state <code>r3.requires = [r1, r2];</code>.</p>
	*  <p> 
	*  Assignment to the requires property is ignored if it occurs 
	*  after a certain stage in the loading process as managed by StartupMonitorProxy (the monitor), as follows
	*  <ul><li>
	*  after invocation of the monitor's loadResources() method, for those resources already listed</li>
	*  <li>after a resource is added to the monitor's list using addResource() or addResources(), when that occurs 
	*  after invocation of loadResources().</li></ul> 
	*  </p>
	*  <p>Each resource adopts a Retry Policy, to govern retries to load resources when a load attempt fails,
	*  and to govern application of timeouts on load attempts.  The utility provides a particular RetryPolicy
	*  class that the client app can use, but the app could also implement its own in accordance with the
	*  IRetryPolicy interface.  However, regardless of retry policy, there is a built-in assumption that 
	*  automatic retries do not occur after timeout.</p>
	*  <p>
	*  Use of the <code>retryPolicy</code> property is as follows
	*  <ul><li>
	*  provides the client app with a means to set a retry policy specific to this resource</li>
	*  <li>the initial value is null; this means use the defaultRetryPolicy from StartupMonitorProxy</li>
	*  <li>the app can set the defaultRetryPolicy property on StartupMonitorProxy</li>
	*  <li>the app can set the retryPolicy property on each resource, but should only bother to do 
	*  so if it differs from defaultRetryPolicy</li>
	*  <li>the app can set this before invoking StartupMonitorProxy.loadResources(), and can also set this later,
	*  in the case where loading finishes incomplete, if a change of policy is required, before invoking
	*  StartupMonitorProxy.tryToCompleteLoadResources</li>
	*  <li>another way to effect a change of policy, where the same input parameters apply to all policy 
	*  instances, is to use the reConfigureAllRetryPolicies() method on StartupMonitorProxy.</li>
	*  </ul></p>
	*  <p>
	*  Adapted from original code of Daniele Ugoletti in his
	*  ApplicationSkeleton_v1.3 demo, Nov 2007, posted to the puremvc forums.
	*  Also from code of Joel Caballero, Feb 2008, posted to the forums.</p>
	*  
	*/
	public class StartupResourceProxy extends Proxy implements IProxy {

        private static const EMPTY :int = 1;
        private static const LOADING :int = 2;
        private static const TIMED_OUT :int = 3;
        private static const FAILED :int = 4;
        private static const LOADED :int = 5;

		private var status :int;

		// StartupResourceProxys, pre-requisites for this resource, if any.
		// These pre-requisites must be loaded before this can be loaded.
		private var _requires :Array;

        private var _appResourceProxy :IStartupProxy;

        private var _retryPolicy :IRetryPolicy;

        private var _monitor :StartupMonitorProxy;

		private var timeoutTimer :Timer;
		private var retryTimer :Timer;
        private var loadingStartTime :Number =0;
        private var requiresAreClosed :Boolean =false;

		public function StartupResourceProxy( proxyName :String, appResourceProxy :IStartupProxy) {
		    super( proxyName );
		    this._appResourceProxy = appResourceProxy;
			this.status = EMPTY;
			this.requires = new Array();
		}

		public function set requires( resources :Array ) :void {
		    if ( ! requiresAreClosed )
		        _requires = resources;
		}
		public function get requires() :Array {
		    return _requires;
		}

        /**
         *  Can only be set when the StartupMonitorProxy is not engaged in loading; for example, 
         *  before loading commences or after loading is "finished incomplete".
         */
		public function set retryPolicy( rp :IRetryPolicy ) :void {
		    if ( monitorIsNotActive() )
		        _retryPolicy = rp;
		}
		public function get retryPolicy() :IRetryPolicy {
		    // lazy instantiation, when setting from defaultRetryPolicy.
		    if ( _retryPolicy == null ) {
		        _retryPolicy = monitor.defaultRetryPolicy.copy();
		    }
		    return _retryPolicy;
		}

		public function get appResourceProxy() :IStartupProxy {
		    return _appResourceProxy;
		}

		public function appResourceProxyName() :String {
		    return _appResourceProxy.getProxyName();
		}

		public function isLoading() :Boolean {
		    return status == LOADING;
		}
		public function isTimedOut() :Boolean {
		    return status == TIMED_OUT;
		}
		public function isFailed() :Boolean {
		    return status == FAILED;
		}
		public function isLoaded() :Boolean {
		    return status == LOADED;
		}

        internal function closeRequires() :void {
            requiresAreClosed = true;
        }
		internal function setStatusToLoading() :void {
		    status = LOADING;
		}
		internal function setStatusToTimedOut() :void {
		    status = TIMED_OUT;
		    resetTimeoutTimer();
	        retryPolicy.setToTimedOut();
		}
		internal function setStatusToFailed() :void {
		    status = FAILED;
		    resetTimeoutTimer();
		    // addFailure arg is: timeToFailure = timeNow - loadingStartTime;
		    retryPolicy.addFailure( new Date().time - loadingStartTime );
		}
		internal function setStatusToLoaded() :void {
		    status = LOADED;
		    resetTimeoutTimer();
		}

		internal function isOkToLoad() :Boolean {
		    if ( status != EMPTY )
		        return false;
		    for( var i:int =0; i < requires.length; i++) {
		        if ( ! (requires[i] as StartupResourceProxy).isLoaded() )
		            return false;
		    }
		    return true;
		}
		internal function isOkToSetLoaded() :Boolean {
		    return status == LOADING;
		}
		internal function isOkToSetFailed() :Boolean {
		    return status == LOADING;
		}

		internal function isOkToRetry() :Boolean {
		    if ( status != FAILED )
		        return false;
		    return retryPolicy.isOkToRetry();
		}
		internal function startLoad() :void {
		    if ( retryPolicy.isTimeoutApplicable() ) {
    		    timeoutTimer = retryPolicy.getTimeoutTimer();
    		    if ( timeoutTimer )
		            startTimeoutTimer();
		    }
		    loadingStartTime = new Date().time; // now
		    appResourceProxy.load();
		}
		internal function startRetry() :void {
		    retryTimer = retryPolicy.getRetryTimer();
		    if ( retryTimer )
		        startRetryTimer();
		    else
		        // no delay with this retry, proceed immediately to retry the load
		        startLoad();
		}

		internal function isOkToReset() :Boolean {
		    return !( status == LOADING || status == LOADED )
		}
		internal function reset() :void {
		    status = EMPTY;
		    retryPolicy.reset();
		}

		private function startTimeoutTimer() :void {
		    timeoutTimer.addEventListener( TimerEvent.TIMER, timedOut );		        
		    timeoutTimer.start();
		}
		private function resetTimeoutTimer() :void {
		    if ( timeoutTimer != null )
		        timeoutTimer.reset();
		}
		private function timedOut( e :TimerEvent ) :void {
	        setStatusToTimedOut();
		    monitor.resourceHasBeenTimedOut( this );
		}

		private function startRetryTimer() :void {
		    retryTimer.addEventListener( TimerEvent.TIMER, startLoadOnTimerEvent );		        
		    retryTimer.start();
		}
		private function resetRetryTimer() :void {
		    if ( retryTimer != null )
		        retryTimer.reset();
		}
		private function startLoadOnTimerEvent( e :TimerEvent ) :void {
		    resetRetryTimer();
	        startLoad();
		}

        private function get monitor() :StartupMonitorProxy {
		    // lazy instantiation
		    if ( _monitor == null ) {
		        _monitor = facade.retrieveProxy( StartupMonitorProxy.NAME ) as StartupMonitorProxy;
		    }
		    return _monitor;
        }
        private function monitorIsNotActive() :Boolean {
            return !( monitor && monitor.isActive() );
        }

        /**
         *  Public getter, to facilitate testing.
         */
        public function getLoadingStartTime() :Number { return loadingStartTime; }
	}

}
