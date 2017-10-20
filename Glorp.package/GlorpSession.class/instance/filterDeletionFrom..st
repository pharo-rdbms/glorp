read/write
filterDeletionFrom: anObject

	self hasUnitOfWork ifFalse: [^anObject].
	currentUnitOfWork shouldFilterDeletions ifFalse: [^anObject].
	(currentUnitOfWork willDelete: anObject)
		ifTrue: [^nil].
	^anObject