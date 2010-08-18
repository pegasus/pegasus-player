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

package com.ericfeminella.tests
{
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;
    
    import flexunit.framework.TestSuite;
    
    /**
     * 
     * All static utility class which provides a mechanism for adding
     * a <code>TestCase</code> to a <code>TestSuite</code> for each 
     * method defined by a specific class
     * 
     * @example The following example demonstrates how a class which 
     * extends TestCase can utilize <code>TestSuiteBuilder</code> to
     * automate the creation of the associated <code>TestSuite</code>
     * 
     * <listing version="3.0">
     * 
     * package
     * {
     *    public class ExampleTest extends TestCase 
     *    {
     *        public function testX() : void
     *        {
     *            // test implementation...
     *        }
     * 
     *        public function testY() : void
     *        {
     *            // test implementation...
     *        }
     * 
     *        public function testZ() : void
     *        {
     *            // test implementation...
     *        }
     *    }
     * }
     * 
     * // TestRunner.mxml on creationComplete Event
     * private function onCreationComplete() : void
     * {
     *        testRunner.test = TestSuiteHelper.createSuite( ExampleTest );
     *        testRunner.startTest();
     * }
     * 
     * // creates a new TestSuite and adds each method defined by ExampleTest 
     * // to the suite
     * 
     * </listing>
     * 
     * @see flexunit.framework.TestSuite
     * @see flexunit.framework.TestCase
     * 
     */    
    public final class TestSuiteHelper
    {
        /**
         *
         * Creates a <code>TestSuite</code> and, through introspection,
         * determines all methods defined by a specific class which 
         * extends <code>TestCase</code> and adds each method to the
         * <code>TestSuite</code>
         *  
         * @param   the class or type in which to locate tests
         * @return  a <code>TestSuite</code> containing all of the tests
         * 
         */        
        public static function createSuite( Type:Class, onlyTestPrefix:Boolean = true ) : TestSuite
        {
            var tests:XMLList = getTests( Type );

            var testSuite:TestSuite = new TestSuite();
            
            for each (var methodName:String in tests.@name)
            {
                if(methodName.search("test") > -1 || !onlyTestPrefix )
                	testSuite.addTest( new Type( methodName ) );
            }
            return testSuite;
        }
        
        /**
         *
         * Determines if the specified test has been defined for 
         * a specific class
         *  
         * @param  the class or type in which to locate tests
         * @param  the name of the test which is to be located
         * @return true if the test exists, otherwise false 
         * 
         */        
        public static function hasTest( Type:Class, testName:String) : Boolean
        {
            var result:Boolean = false;
            
            var tests:XMLList = getTests( Type );

            for each (var methodName:String in tests.@name)
            {
                if (methodName == testName)
                {
                    result = true;
                    break;
                }
            }
            return result;
        }
        
        /**
         *
         * @private
         * 
         * Retrieves all tests which have been defined for a specific 
         * <code>TestCase</code> sub class
         * 
         * @param   the class or type in which to locate tests
         * @return  an <code>XMLList</code> containing all test names
         * 
         */        
        private static function getTests( Type:Class ) : XMLList
        {
            var type:String = getQualifiedClassName( Type );
            var definedMethods:XMLList = describeType( Type )..method.(@declaredBy == type).(@name != "suite");

            return definedMethods;
        }
    }
}

