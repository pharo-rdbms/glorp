copying
postCopy

	super postCopy.
	self initializeCache.
	currentUnitOfWork := nil.
	accessor := accessor copy.