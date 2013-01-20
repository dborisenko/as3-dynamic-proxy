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
	public class InterceptedPropertyTest
	{
		protected var proxyHolder:ProxyHolder = new ProxyHolder();

		private var TEST_STRING:String = "test.string";

		[Test(async, ui)]
		public function testProxyWithInterceptedProperty():void
		{
			var proxy:ProxyClass = new ProxyClass();
			// Proxy for only one property (property1) of SourceClass
			proxyHolder.setInterceptedProperty(SourceClass, "property1", proxy, "property2");

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
			// Only this property (property1) is proxied
			var source:SourceClass = proxyHolder.createProxy(SourceClass) as SourceClass;

			assertTrue(source.property1 != SourceClass.PROPERTY_1_RETURN_STRING);
			assertTrue(source.property1 == ProxyClass.PROPERTY_2_RETURN_STRING);

			source.property1 = TEST_STRING;

			assertTrue(source.property1 == TEST_STRING);

			// Other methods and properties are called from SourceClass
			source.addPrefixToProperty1();

			assertTrue(source.property1 == (SourceClass.PREFIX + TEST_STRING));
			assertTrue(source.property1 != (ProxyClass.PREFIX + TEST_STRING));
		}
	}
}
