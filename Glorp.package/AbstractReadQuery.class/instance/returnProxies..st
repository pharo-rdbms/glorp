accessing
returnProxies: aBoolean
	
	aBoolean ifTrue: [proxyType := Proxy] ifFalse: [proxyType := nil]