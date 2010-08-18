/*
	PureMVC Utility - Startup Manager - Manage loading of data resources at application startup
	Copyright (c) 2008-, collaborative, as follows
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
    import org.puremvc.as3.multicore.utilities.startupmanager.interfaces.IRetryParameters;

	/**
	*  See the <code>StartupMonitorProxy</code> class for the primary documentation on the
	*  Startup Manager utility.
	*  Within the utility, it is the <code>StartupResourceProxy</code>class that interacts with 
	*  <code>RetryPolicy</code>.
	*  See the demo app called StartupAsOrdered as an example of
	*  how <code>RetryPolicy</code> can be used.  In particular, see LoadResourcesCommand in
	*  that app.
	*  <p>
	*  This RetryPolicy is the standard implementation of a Retry Policy for the Startup Manager.
	*  It implements the IRetryPolicy interface.  A client app could implement this interface differently 
	*  and hence have a different retry policy when using the Startup Manager.  Each startup resource
	*  must reference an instance of IRetryPolicy.  It uses this policy to manage retries of failed loads
	*  and to manage timeout on loading.</p>
	*  <p>
	*  This standard Retry Policy is as follows
	*  <ul><li>
	*  takes configuration parameters: maxRetries, retryInterval (secs), timeout (secs) </li>
	*  <li>these parameters are supplied via an IRetryParameters object</li>
	*  <li>when maxRetries is non-zero, on failure to load a resource, the utility will automatically retry
	*  to load it, but will only retry 'maxRetries' times</li>
	*  <li>the start of each retry will be delayed 'retryInterval' seconds</li>
	*  <li>a timeout of zero means timeout is not applicable</li>
	*  <li>timeout is the limit on load time; when it is exceeded, the load of the resource is abandoned, 
	*  it has 'timed out'; load time means the cumulative time of load and retries</li>
	*  <li>the elapsed time for loads and retry loads, for comparison with the timeout figure, is accumulated
	*  as follows: it is the sum of the time for the first load attempt and the times for each retry attempt; the
	*  retryInterval is not included</li>
	*  </ul></p>
	*  
	*/
	public class RetryPolicy implements IRetryPolicy {

        protected var retryParameters :IRetryParameters;
        protected var failedCount :int =0;
        protected var failedTimeAccumulated :Number =0; //secs
        protected var timedOut :Boolean =false;
        
		public function RetryPolicy( retryParameters :IRetryParameters ) {
		    this.retryParameters = retryParameters;
		}
		public function get maxRetries() :int { return retryParameters.maxRetries; }

		public function get retryInterval() :Number { return retryParameters.retryInterval; }

        public function get timeout() :Number { return retryParameters.timeout; }

        /**
         *  @see org.puremvc.as3.multicore.utilities.startupmanager.interfaces.IRetryPolicy#copy() IRetryPolicy#copy()
         */
        public function copy() :IRetryPolicy {
            return new RetryPolicy( retryParameters );
        }

        /**
         *  Reset this policy as regards the configuration parameters and the state variables
         *  that have tracked activity to-date.  Should only be done when users of the policy
         *  have finished with the current state.
         *  @see org.puremvc.as3.multicore.utilities.startupmanager.interfaces.IRetryPolicy#reConfigure() IRetryPolicy#reConfigure()
         */
        public function reConfigure( retryParameters :IRetryParameters ) :void {
            this.retryParameters = retryParameters;
            reset();
        }

        /**
         *  Updates internal state.
         *  Includes setting to a timedOut state if that is
         *  an outcome, though would normally expect the timedOut state to
         *  be recognised and set by another object e.g. StartupResourceProxy.
         *  @param timeToFailure Time elapsed from start of operation until failure; unit is msecs.
         */
        public function addFailure( timeToFailure :Number ) :void {
            failedCount++;
            failedTimeAccumulated += (timeToFailure / 1000);
            if ( isTimeoutApplicable() && failedTimeAccumulated >= timeout )
                setToTimedOut();
        }
        public function isOkToRetry() :Boolean {
            return !timedOut && failedCount > 0 && ( failedCount <= maxRetries );
        }

        /**
         *  @see org.puremvc.as3.multicore.utilities.startupmanager.interfaces.IRetryPolicy#reset() IRetryPolicy#reset()
         */
        public function reset() :void {
            failedCount = 0;
            failedTimeAccumulated = 0;
            timedOut = false;
        }

        public function isTimeoutApplicable() :Boolean {
            return retryParameters.timeout > 0;
        }

        /**
         *  @see org.puremvc.as3.multicore.utilities.startupmanager.interfaces.IRetryPolicy#getTimeoutTimer() IRetryPolicy#getTimeoutTimer()
         */
        public function getTimeoutTimer() :Timer {
            if ( !isTimeoutApplicable() || timedOut )
                return null;
		    return new Timer( ( timeout - failedTimeAccumulated ) *1000, 1 );
        }

        public function setToTimedOut() :void {
            timedOut = true;
        }
        public function isTimedOut() :Boolean { return timedOut; }

        /**
         *  @see org.puremvc.as3.multicore.utilities.startupmanager.interfaces.IRetryPolicy#getRetryTimer() IRetryPolicy#getRetryTimer()
         */
        public function getRetryTimer() :Timer {
            if ( retryInterval > 0 )
		        return new Timer( retryInterval *1000, 1 );
		    else
		        return null;
        }

        public function getFailedCount() :int { return failedCount; }

        public function getFailedTimeAccumulated() :Number { return failedTimeAccumulated; }

        public function getRetryParameters() :IRetryParameters { return retryParameters; }
	}

}
