private/caching
cacheFor: anObject
	"Get the cache for a particular object. Since this could conceivably be passed a proxy, check for that. The cache for an uninstantiated proxy is kind of ambiguous, treat it as nil.  This could also be a class"

	| nonMetaClass |
	nonMetaClass := anObject isBehavior ifTrue: [anObject] ifFalse: [anObject class].
	^nonMetaClass == Proxy
		ifTrue: [anObject isInstantiated ifTrue: [self cacheFor: anObject getValue] ifFalse: [nil]]
		ifFalse: [self cacheForClass: nonMetaClass].