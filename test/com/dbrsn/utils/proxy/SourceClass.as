package com.dbrsn.utils.proxy
{

	/**
	 *
	 * @author Denis Borisenko
	 *
	 */
	public class SourceClass
	{
		public static const PREFIX:String = "source.";

		public static const METHOD_1_RETURN_STRING:String = PREFIX + "method1";

		public static const PROPERTY_1_RETURN_STRING:String = PREFIX + "property1";

		private var _property1:String = PROPERTY_1_RETURN_STRING;

		public function SourceClass()
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
