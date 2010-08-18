/*
 Copyright (c) 2007 Eric J. Feminella  <eric@ericfeminella.com>
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

package com.ericfeminella.sql
{
    import flash.events.SQLEvent;

    /**
     * 
     * Defines the contract for classes which must provide an
     * API which handles <code>SQLEvent</code> objects dispatched 
     * via a <code>SQLConnection</code> instance
     * 
     */
    public interface ISQLConnectionResponder
    {
        /**
         * 
         * Handles a SQLEvent of type SQLEvent.OPEN which is dispatched 
         * when a SQLConnection.open(); method call completes successfully
         * 
         * @param the SQLEvent instance which was dispatched
         * 
         */    
        function open(event:SQLEvent) : void;

        /**
         * 
         * Handles a SQLEvent of type SQLEvent.ATTACH which is dispatched 
         * when a SQLConnection.attach(); method call completes successfully
         * 
         * @param the SQLEvent instance which was dispatched
         * 
         */    
        function attach(event:SQLEvent) : void;

        /**
         * 
         * Handles a SQLEvent of type SQLEvent.DETACH which is dispatched 
         * when a SQLConnection.detach(); method call completes successfully
         * 
         * @param the SQLEvent instance which was dispatched
         * 
         */    
        function detach(event:SQLEvent) : void;

        /**
         * 
         * Handles a SQLEvent of type SQLEvent.ANALYZE which is dispatched 
         * when a SQLConnection.analyze(); method call completes successfully
         * 
         * @param the SQLEvent instance which was dispatched
         * 
         */    
        function analyze(event:SQLEvent) : void;
        
        /**
         * 
         * Handles a SQLEvent of type SQLEvent.DEANALYZE which is dispatched 
         * when a SQLConnection.deanalyze(); method call completes successfully
         * 
         * @param the SQLEvent instance which was dispatched
         * 
         */    
        function deanalyze(event:SQLEvent) : void;

        /** 
         * 
         * Handles a SQLEvent of type SQLEvent.COMMIT which is dispatched 
         * when a SQLConnection.commit(); method call completes successfully
         * 
         * @param the SQLEvent instance which was dispatched
         * 
         */        
        function commit(event:SQLEvent) : void;

        /**
         * 
         * Handles a SQLEvent of type SQLEvent.CLOSE which is dispatched 
         * when a SQLConnection.close(); method call completes successfully
         * 
         * @param the SQLEvent instance which was dispatched
         * 
         */    
        function close(event:SQLEvent) : void;

        /**
         * 
         * Handles a SQLEvent of type SQLEvent.ROLLBACK which is dispatched 
         * when a SQLConnection.rollback(); method call completes successfully
         * 
         * @param the SQLEvent instance which was dispatched
         * 
         */    
        function rollback(event:SQLEvent) : void;
        
        /**
         * 
         * Handles a SQLEvent of type SQLEvent.CLEAN which is dispatched 
         * when a SQLConnection.clean(); method call completes successfully
         * 
         * @param the SQLEvent instance which was dispatched
         * 
         */    
        function clean(event:SQLEvent) : void;

        /** 
         * 
         * Handles a SQLEvent of type SQLEvent.BEGIN which is dispatched 
         * when a SQLConnection.begin(); method call completes successfully
         * 
         * @param the SQLEvent instance which was dispatched
         * 
         */    
        function begin(event:SQLEvent) : void;
    }
}
