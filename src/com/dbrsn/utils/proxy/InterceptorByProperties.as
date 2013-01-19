package com.dbrsn.utils.proxy
{
	import flash.utils.Dictionary;

	import org.floxy.IInterceptor;
	import org.floxy.IInvocation;

	/**
	 *
	 * @author Denis Borisenko
	 *
	 */
	public class InterceptorByProperties extends InterceptorClass implements IInterceptor
	{
		protected var interceptionsInfoDic:Dictionary = new Dictionary();

		public function InterceptorByProperties()
		{
			super();
		}

		public function setInterceptedProperty(sourcePropertyName:String, destination:Object, destinationPropertyName:String = null, canProceed:Boolean = false):void
		{
			setInterceptedPropertyInfo(sourcePropertyName, new InfoProperty(destination, destinationPropertyName || sourcePropertyName, canProceed));
		}

		public function setInterceptedPropertyInfo(sourcePropertyName:String, info:InfoProperty):void
		{
			interceptionsInfoDic[sourcePropertyName] = info;
		}

		protected function getInterceptedProperty(propertyName:String):InfoProperty
		{
			return interceptionsInfoDic[propertyName] as InfoProperty;
		}

		protected function hasProperty(propertyName:String):Boolean
		{
			return getInterceptedProperty(propertyName) != null;
		}

		/**
		 *
		 * @return true, if need to proceed
		 *
		 */
		override protected function interceptGetProperty(invocation:IInvocation):Boolean
		{
			var info:InfoProperty = getInterceptedProperty(invocation.property.name);
			if (info)
			{
				invocation.returnValue = info.getValue();
				return false;
			}
			return true;
		}

		/**
		 *
		 * @return true, if need to proceed
		 *
		 */
		override protected function interceptSetProperty(invocation:IInvocation):Boolean
		{
			var info:InfoProperty = getInterceptedProperty(invocation.property.name);
			if (info)
			{
				info.setValue(invocation.arguments[0]);
				return info.canProceed;
			}
			return true;
		}

		/**
		 *
		 * @return true, if need to proceed
		 *
		 */
		override protected function interceptMethod(invocation:IInvocation):Boolean
		{
			var info:InfoProperty = getInterceptedProperty(invocation.method.name);
			if (info)
			{
				invocation.returnValue = info.call(invocation.arguments);
				return info.canProceed;
			}
			return true;
		}
	}
}
