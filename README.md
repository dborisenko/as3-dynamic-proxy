Dynamic Proxy for ActionScript 3.0
=================

Dynamic proxy allows to intercept class source behaviour by proxy, which doesn't extend source class. 
Proxeing is configured by different types of interceptors.

# Examples #
## Intercept the whole class by another class ##
```actionscript
var proxyHolder:ProxyHolder = new ProxyHolder();

// ProxyClass is dynamic proxy for SourceClass
proxyHolder.setInterceptedClass(SourceClass, new ProxyClass());
proxyHolder.addEventListener(Event.COMPLETE, onProxyComplete);
proxyHolder.addEventListener(ErrorEvent.ERROR, onProxyError);
proxyHolder.addEventListener(IOErrorEvent.IO_ERROR, onProxyError);
proxyHolder.init();

function onProxyComplete(event:Event):void
{
  // Create proxy for SourceClass. Real instance will be instance of ProxyClass
  var source:SourceClass = proxyHolder.createProxy(SourceClass) as SourceClass;
  
  // Setter and getter of ProxyClass, because the whole SourceClass is dynamically proxied by ProxyClass
  source.property1 = TEST_STRING;
  trace(source.property1);
  
  // And method is called from ProxyClass
  source.addPrefixToProperty1();
}
```

## Intercept specified method by other method ##
```actionscript
var proxyHolder:ProxyHolder = new ProxyHolder();

var proxy:ProxyClass = new ProxyClass();
// Proxy for only one property (property1) of SourceClass
proxyHolder.setInterceptedProperty(SourceClass, "property1", proxy, "property2");

proxyHolder.addEventListener(Event.COMPLETE, onProxyComplete);
proxyHolder.addEventListener(ErrorEvent.ERROR, onProxyError);
proxyHolder.addEventListener(IOErrorEvent.IO_ERROR, onProxyError);
proxyHolder.init();

function onProxyComplete(event:Event):void
{
  // Only this property (property1) is proxied
  var source:SourceClass = proxyHolder.createProxy(SourceClass) as SourceClass;

  // Setter and getter of ProxyClass. Other properties and methods will be from SourceClass
  source.property1 = TEST_STRING;
  trace(source.property1);
}
```
