package com.dbrsn.utils.proxy
{
	import org.floxy.IInterceptor;
	import org.floxy.IInvocation;

	/**
	 *
	 * @author Denis Borisenko
	 *
	 */
	public class InterceptorClass implements IInterceptor
	{
		public var destination:Object;

		public function InterceptorClass(destination:Object = null)
		{
			this.destination = destination;
		}

		public function intercept(invocation:IInvocation):void
		{
			var needToProceed:Boolean = false;
			if (invocation.property)
			{
				needToProceed = interceptProperty(invocation);
			}
			else if (invocation.method)
			{
				needToProceed = interceptMethod(invocation);
			}
			else
			{
				needToProceed = true;
			}

			if (needToProceed && invocation.canProceed)
			{
				invocation.proceed();
			}
		}

		/**
		 *
		 * @return true, if need to proceed
		 *
		 */
		protected function interceptProperty(invocation:IInvocation):Boolean
		{
			if (invocation.method == invocation.property.getMethod)
			{
				return interceptGetProperty(invocation);
			}
			else if (invocation.method == invocation.property.setMethod)
			{
				return interceptSetProperty(invocation);
			}
			return true;
		}

		/**
		 *
		 * @return true, if need to proceed
		 *
		 */
		protected function interceptGetProperty(invocation:IInvocation):Boolean
		{
			var name:String = invocation.property.name;
//			trace("Intercepted [function get {0}():*]", name);
			if (destination && name in destination)
			{
				invocation.returnValue = destination[name];
				return false;
			}
			return true;
		}

		/**
		 *
		 * @return true, if need to proceed
		 *
		 */
		protected function interceptSetProperty(invocation:IInvocation):Boolean
		{
			var name:String = invocation.property.name;
//			trace("Intercepted [function set {0}(...)]", name);
			if (destination && name in destination)
			{
				destination[name] = invocation.arguments[0];
				return false;
			}
			return true;
		}

		/**
		 *
		 * @return true, if need to proceed
		 *
		 */
		protected function interceptMethod(invocation:IInvocation):Boolean
		{
			var name:String = invocation.method.name;
//			trace("Intercepted [function {0}(...):*]", name);
			var func:Function = destination[name] as Function;
			if (func != null)
			{
				invocation.returnValue = func.apply(destination, invocation.arguments);
				return false;
			}
			return true;
		}
	}
}
