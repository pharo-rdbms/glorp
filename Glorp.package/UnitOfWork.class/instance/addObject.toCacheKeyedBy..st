private/mapping
addObject: eachObject toCacheKeyedBy: key 

	| tracker |	
	self session cacheAt: key put: eachObject.
	tracker := self session modificationTracker.
	tracker isNil ifFalse: [tracker track: eachObject]