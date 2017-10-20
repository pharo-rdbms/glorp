initialize
reset
	self initializeCache.
	self releaseReaper.
	accessor reset.
	currentUnitOfWork := nil.
	modificationTracker release.
	modificationTracker isNil ifFalse: [modificationTracker := #needed].