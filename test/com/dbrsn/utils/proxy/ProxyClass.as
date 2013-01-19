package com.dbrsn.utils.proxy
{

	/**
	 *
	 * @author Denis Borisenko
	 *
	 */
	public class ProxyClass
	{
		public static const PREFIX:String = "proxy.";

		public static const METHOD_1_RETURN_STRING:String = PREFIX + ".method1";

		public static const PROPERTY_1_RETURN_STRING:String = PREFIX + "property1";

		public static const PROPERTY_2_RETURN_STRING:String = PREFIX + "property2";

		private var _property1:String = PROPERTY_1_RETURN_STRING;

		private var _property2:String = PROPERTY_2_RETURN_STRING;

		public function ProxyClass()
		{
		}

		public function get property1():String
		{
			return _property1;
		}

		public function set property1(value:String):void
		{
			_property1 = value;
		}

		public function get property2():String
		{
			return _property2;
		}

		public function set property2(value:String):void
		{
			_property2 = value;
		}

		public function method1():String
		{
			return METHOD_1_RETURN_STRING;
		}

		public function addPrefixToProperty1():void
		{
			property1 = PREFIX + property1;
		}
	}
}
