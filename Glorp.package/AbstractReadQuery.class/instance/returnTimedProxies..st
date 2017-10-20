accessing
returnTimedProxies: aBoolean

	aBoolean ifTrue: [proxyType := TimedProxy] ifFalse: [proxyType := nil]