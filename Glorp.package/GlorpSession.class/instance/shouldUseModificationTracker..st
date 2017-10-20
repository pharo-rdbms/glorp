initialize
shouldUseModificationTracker: aBoolean
	aBoolean
		ifTrue: [modificationTracker isNil ifTrue: [self useModificationTracker]]
		ifFalse: [modificationTracker := nil].