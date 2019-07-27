initialize/release
makeCacheFor: aClass 
	| rootClass cache |
	rootClass := session isNil ifTrue: [aClass] ifFalse: [
		session system cacheKeyClassFor: aClass].
	cache := subCaches at: rootClass ifAbsentPut: [ Cache newFor: rootClass in: self ].
	"subCaches at: aClass put: cache."
	^cache