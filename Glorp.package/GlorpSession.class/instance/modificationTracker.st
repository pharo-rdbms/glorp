accessing
modificationTracker
	"If we killed off the tracker due to a session reset, then bring it back again."
	modificationTracker == #needed ifTrue: [self useModificationTracker].
	^modificationTracker