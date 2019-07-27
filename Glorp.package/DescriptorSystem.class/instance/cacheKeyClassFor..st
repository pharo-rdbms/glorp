accessing
cacheKeyClassFor: aClass
	^(self descriptorFor: aClass) ifNil: [aClass] ifNotNil: [:descriptor | descriptor typeResolver cacheKeyClassFor: aClass]