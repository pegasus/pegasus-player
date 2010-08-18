/*
 Copyright (c) 2006 Eric J. Feminella <eric@ericfeminella.com>
 All rights reserved.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 @internal
 */

package com.ericfeminella.utils
{
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    /**
     *
     * All static class which provides an API for working with
     * Managed Timer instances. This class is intended to provide
     * a central entry point from which <code>Timer</code> instances
     * can be created and controlled
     *
     * @see flash.events.TimerEvent
     * @see flash.utils.Timer
     *
     */
    public final class ManagedTimer
    {
        /**
         *
         * The <code>Timer</code> instance from which all managed
         * <code>Timer</code> instances execute
         *
         */
        private static var timer:Timer;

        /**
         *
         * The handler which is invoked upon each <code>Timer</code>
         * interval execution
         *
         */
        private static var intervalHandler:Function;

        /**
         *
         * The handler which is invoked upon each <code>Timer</code>
         * complete execution
         *
         */
        private static var completeHandler:Function;

        /**
         *
         * Creates a timer instance and dispatches events to specific
         * interval and complete functions
         *
         * @param the delay between timer events, in milliseconds.
         * @param specifies the number of repetitions
         * @param a interval callback function
         * @param a complete callback function
         *
         */
        public static function create(interval:int, duration:int, intervalHandler:Function, completeHandler:Function) : void
        {
            ManagedTimer.intervalHandler = intervalHandler;
            ManagedTimer.completeHandler = completeHandler;

            timer = new Timer( interval, duration );
            timer.addEventListener( TimerEvent.TIMER, intervalHandler, false, 0, true );
            timer.addEventListener( TimerEvent.TIMER_COMPLETE, completeHandler, false, 0, true );
            timer.start();
        }

        /**
         *
         * Immediatly stops the current timer and removes all listeners
         *
         */
        public static function stop() : void
        {
            timer.reset();
            timer.stop();
            timer.removeEventListener( TimerEvent.TIMER, intervalHandler );
            timer.removeEventListener( TimerEvent.TIMER_COMPLETE, completeHandler );
        }
    }
}
