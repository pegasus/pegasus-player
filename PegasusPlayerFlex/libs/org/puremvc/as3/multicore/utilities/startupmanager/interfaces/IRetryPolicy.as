/*
	PureMVC Utility - Startup Manager - Manage loading of data resources at application startup
	Copyright (c) 2008-, collaborative, as follows
	2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/

package org.puremvc.as3.multicore.utilities.startupmanager.interfaces
{
    import flash.utils.Timer;

    /**
     *  The retry policy used by StartupResourceProxy must implement this interface.
     */
	public interface IRetryPolicy {

        /**
         *  The relevant operation, original or retry, has failed.
         *  @param timeToFailure Time elapsed from start of operation until failure; unit is msecs.
         */
        function addFailure( timeToFailure :Number ) :void;

        function isOkToRetry() :Boolean;

        function isTimeoutApplicable() :Boolean;

        /**
         *  Returns a Timer, where the delay is the timeout that should now apply, and the
         *  repeat count is 1.
         *  Returns null when timeout is not applicable.
         */
        function getTimeoutTimer() :Timer;

        function setToTimedOut() :void;

        function isTimedOut() :Boolean;

        /**
         *  Returns a Timer, where the delay is the time to wait until starting a retry operation, 
         *  and the repeat count is 1.
         *  Returns null when the delay is zero.
         */
        function getRetryTimer() :Timer;

        /**
         *  Reset state variables that have tracked retry activity; reset them to their initial values.
         */
        function reset() :void;

        /**
         *  Return an exact copy of this retry policy.
         */
        function copy() :IRetryPolicy;

        /**
         *  Re-initialize this policy, using a new set of input parameters, and resetting state variables as 
         *  carried out by the reset() method.
         */
        function reConfigure( params :IRetryParameters ) :void;

        /**
         *  Number of failures so far, including first failure and any subsequent retries that failed.
         */
        function getFailedCount() :int;

        /**
         *  Elapsed time for first attempt plus subsequent retries.
         */
        function getFailedTimeAccumulated() :Number;

        function getRetryParameters() :IRetryParameters;

	}
}
