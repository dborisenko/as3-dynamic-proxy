package com.dbrsn.utils.proxy
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	import org.floxy.IInterceptor;
	import org.floxy.ProxyRepository;

	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "error", type = "flash.events.ErrorEvent")]
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]
	/**
	 *
	 * @author Denis Borisenko
	 *
	 */
	public class ProxyHolder extends EventDispatcher
	{
		protected var proxyRepository:ProxyRepository;

		protected var initialized:Boolean = false;

		protected var classesForProxying:Array = [];

		protected var interceptorDic:Dictionary = new Dictionary();

		public function init():void
		{
			if (!initialized)
			{
				proxyRepository = new ProxyRepository();
				if (classesForProxying && classesForProxying.length > 0)
				{
					var result:IEventDispatcher = proxyRepository.prepare(classesForProxying, ApplicationDomain.currentDomain);

					result.addEventListener(Event.COMPLETE, onInitComplete);
					result.addEventListener(IOErrorEvent.IO_ERROR, onError);
					result.addEventListener(ErrorEvent.ERROR, onError);
				}
			}
		}

		protected function onInitComplete(event:Event):void
		{
//			trace("Proxy is initialized");
			initialized = true;
			dispatchEvent(event);
		}

		protected function onError(event:ErrorEvent):void
		{
//			trace("Error of initializing proxy: {0}", event.toString());
			dispatchEvent(event);
		}

		public function createProxy(clazz:Class, args:Array = null):Object
		{
			if (!initialized)
			{
				throw new Error("Proxy is not yet initialized");
			}

			var interceptor:IInterceptor = getInterceptor(clazz);
			if (interceptor)
			{
				return proxyRepository.create(clazz, args || [], interceptor);
			}
			return null;
		}

		protected function getInterceptor(clazz:Class):IInterceptor
		{
			return interceptorDic[clazz] as IInterceptor;
		}

		public function setInterceptor(clazz:Class, interceptor:IInterceptor):void
		{
			if (classesForProxying.indexOf(clazz) == -1)
			{
				classesForProxying.push(clazz);
			}
			interceptorDic[clazz] = interceptor;
		}

		public function setInterceptedClass(clazz:Class, destination:Object):void
		{
			var interceptor:IInterceptor = getInterceptor(clazz);
			if (!interceptor)
			{
				interceptor = new InterceptorClass(destination);
				setInterceptor(clazz, interceptor);
			}
		}

		public function setInterceptedPropertyInfo(clazz:Class, sourcePropertyName:String, info:InfoProperty):void
		{
			var interceptor:IInterceptor = getInterceptor(clazz);
			if (!interceptor)
			{
				interceptor = new InterceptorByProperties();
				setInterceptor(clazz, interceptor);
			}

			if (interceptor is InterceptorByProperties)
			{
				InterceptorByProperties(interceptor).setInterceptedPropertyInfo(sourcePropertyName, info);
			}
		}

		public function setInterceptedProperty(clazz:Class, sourcePropertyName:String, destination:Object, destinationPropertyName:String = null, canProceed:Boolean = false):void
		{
			setInterceptedPropertyInfo(clazz, sourcePropertyName, new InfoProperty(destination, destinationPropertyName || sourcePropertyName, canProceed));
		}
	}
}
