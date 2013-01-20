package com.dbrsn.utils.proxy
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	import org.flexunit.asserts.assertTrue;

	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;

	/**
	 *
	 * @author Denis Borisenko
	 *
	 */
	public class InterceptedClassTest
	{
		protected var proxyHolder:ProxyHolder = new ProxyHolder();

		private var TEST_STRING:String = "test.string";

		[Test(async, ui)]
		public function testProxyWithInterceptedClass():void
		{
			// ProxyClass is dynamic proxy for SourceClass
			proxyHolder.setInterceptedClass(SourceClass, new ProxyClass());

			proxyHolder.addEventListener(Event.COMPLETE, Async.asyncHandler(this, onTestProxyWithInterceptedClass, 10000));
			proxyHolder.addEventListener(ErrorEvent.ERROR, Async.asyncHandler(this, onProxyError, 10000));
			proxyHolder.addEventListener(IOErrorEvent.IO_ERROR, Async.asyncHandler(this, onProxyError, 10000));
			proxyHolder.init();
		}

		private function onProxyError(event:ErrorEvent, obj:Object):void
		{
			fail("Error of creating dynamic proxy: " + event.toString());
		}

		private function onTestProxyWithInterceptedClass(event:Event, obj:Object):void
		{
			// Create proxy for SourceClass. Real instance will be instance of ProxyClass
			var source:SourceClass = proxyHolder.createProxy(SourceClass) as SourceClass;

			assertTrue(source.method1() != SourceClass.METHOD_1_RETURN_STRING);
			assertTrue(source.property1 != SourceClass.PROPERTY_1_RETURN_STRING);
			assertTrue(source.method1() == ProxyClass.METHOD_1_RETURN_STRING);
			assertTrue(source.property1 == ProxyClass.PROPERTY_1_RETURN_STRING);

			// Setter of ProxyClass, because the whole SourceClass is dynamically proxied by ProxyClass
			source.property1 = TEST_STRING;

			assertTrue(source.property1 == TEST_STRING);

			// And method is called from ProxyClass
			source.addPrefixToProperty1();

			assertTrue(source.property1 != (SourceClass.PREFIX + TEST_STRING));
			assertTrue(source.property1 == (ProxyClass.PREFIX + TEST_STRING));
		}
	}
}
