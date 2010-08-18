/*
 Copyright (c) 2006 Eric J. Feminella  <eric@ericfeminella.com>
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

package com.ericfeminella.display
{
    import mx.core.Application;
    import mx.controls.Alert;
    import mx.events.CloseEvent;
    import flash.display.Sprite;

    /**
     *
     * Alert Helper class which handles displaying a Alert window
     * which contains a custom title, message and handlers for OK,
     * Cancel, Yes and No
     *
     * @example
     *
     * <listing verison="3.0">
     *
     * import com.ericfeminella.display.AlertWindowHelper;
     *
     * AlertWindowHelper.show( "test", "this is a test", 1, confirm, cancel )
     *
     * private function confirm() : void
     * {
     *       trace("confirm");
     * }
     *
     * private function cancel() : void
     * {
     *     trace(evt.detail);
     * }
     *
     * </listing>
     *
     */
    public final class AlertWindowHelper
    {
        public static const DISPLAY_YES_NO:int     = 1;
        public static const DISPLAY_OK_CANCEL:int  = 2;
        private static var confirm:Function;
        private static var cancel:Function;

        /**
         *
         * Displays an Alert window which contains a custom title, message and
         * eventHandlers for OK, Cancel, Yes and No click events
         *
         * @param The title to display in the Alert window
         * @param The message to display in the Alert window
         * @param buttons which to display; DISPLAY_YES_NO or DISPLAY_OK_CANCEL
         * @param handles click events for both OK and Yes buttons
         * @param handles click events for both Cancel and No buttons
         *
         */
        public static function show(title:String, message:String, displayType:int, confirm:Function, cancel:Function) : void
        {
            AlertWindowHelper.confirm = confirm;
            AlertWindowHelper.cancel  = cancel;

            switch ( displayType )
            {
                case DISPLAY_YES_NO :
                   Alert.show( message, title, Alert.YES | Alert.NO, Application.application as Sprite, closeHandler );
                   break;
                case DISPLAY_OK_CANCEL :
                   Alert.show( message, title, Alert.OK | Alert.CANCEL, Application.application as Sprite, closeHandler );
                   break;
                default :
                   Alert.show( message, title, 0, Application.application as Sprite, closeHandler );
                   break;
            }
        }

        /**
         *
         * @private
         *
         * Handles the <code>CloseEvent</code> for all <code>AlertWindowHelper</code>
         *
         * @param <code>CloseEvent</code> which is handled by the specified handler
         *
         */
        private static function closeHandler(evt:CloseEvent) : void
        {
            switch( evt.detail )
            {
                case Alert.YES :
                case Alert.OK  :
                   confirm();
                   break;
                case Alert.NO :
                case Alert.CANCEL :
                   cancel();
                   break;
            }
        }
    }
}
