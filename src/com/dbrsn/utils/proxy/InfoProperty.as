package com.dbrsn.utils.proxy
{

	/**
	 *
	 * @author Denis Borisenko
	 *
	 */
	public class InfoProperty
	{
		public var destination:Object;

		public var name:String;

		public var canProceed:Boolean = false;

		public function InfoProperty(destination:Object, name:String, canProceed:Boolean = false)
		{
			this.destination = destination;
			this.name = name;
			this.canProceed = canProceed;
		}

		public function setValue(value:Object):void
		{
			if (destination && name in destination)
			{
				destination[name] = value;
			}
		}

		public function getValue():Object
		{
			if (destination && name in destination)
			{
				return destination[name];
			}
			return null;
		}

		public function call(args:Array):Object
		{
			var func:Function = destination[name] as Function;
			if (func != null)
			{
				return func.apply(destination, args);
			}
			return null;
		}
	}
}
