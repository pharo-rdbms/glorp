settings
shouldResetExpiryTimeForObjectOfClass: aClass readFrom: aQuery
	"Return true if, when an object is read from a query, even if it's not refreshing. we 'touch' it, resetting its expiry time. By default, we do this if the cache policy for that type of object will remove from the cache. The rationale is that this means we're using the object. Removing an object in use is a very bad thing, and can cause loss of identity and other bad things. However, if expiry only indicates a need to refresh, we don't need to touch the object. Subclasses can override to provide different behaviour."

	aQuery shouldRefresh ifTrue: [^true].
	aQuery returnProxies ifTrue: [^false].
	^(self session cacheForClass: aClass)  willRemoveItems