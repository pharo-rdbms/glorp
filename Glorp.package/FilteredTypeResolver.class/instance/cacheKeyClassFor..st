cache
cacheKeyClassFor: aClass
	^ self useRootClassCache
		ifTrue: [ self rootClass ]
		ifFalse: [ aClass ]