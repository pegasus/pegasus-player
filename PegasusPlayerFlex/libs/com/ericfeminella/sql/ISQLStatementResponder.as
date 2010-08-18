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
     * Defines the contract for classes which must provide an API 
     * which handles <code>SQLEvent</code> objects dispatched via 
     * a <code>SQLStatement</code> instance which have executed 
     * successfully
     * 
     */
    public interface ISQLStatementResponder
    {
        /**
         * 
         * Handles a <code>SQLEvent</code> of type <code>RESULT</code> 
         * which is dispatched when a S<code>QLStatement.execute()</code> 
         * or <code>SQLStatement.next()</code> method call completes 
         * successfully
         * 
         * @param <code>SQLEvent</code> instance which was dispatched
         *  
         */        
        function result(event:SQLEvent) : void;
        
        /**
         * 
         * Handles a <code>SQLEvent</code> of type <code>PREPARE</code> 
         * which is dispatched when a <code>SQLStatement.prepare()</code> 
         * method call completes successfully
         * 
         * @param <code>SQLEvent</code> instance which was dispatched
         * 
         */    
        function prepare(event:SQLEvent) : void;
        
        /**
         * 
         * Handles a <code>SQLEvent</code> of type <code>RESET</code> which 
         * is dispatched when a <code>SQLStatement.reset()</code> method call
         * completes successfully
         * 
         * @param <code>SQLEvent</code> instance which was dispatched
         * 
         */    
        function reset(event:SQLEvent) : void;
    }
}
