reaping
reapExpiredObjects
	| numberReaped |
	[mutex wait.
	keysSortedByExpiryTime isEmpty ifTrue: [self finish].
	done ifTrue: [^self].
	numberReaped := self privateReapObjects.	"If the cache is empty, shut down"
	numberReaped timesRepeat: [keysSortedByExpiryTime removeFirst].
	indexOffset := indexOffset + numberReaped] ensure: [mutex signal].