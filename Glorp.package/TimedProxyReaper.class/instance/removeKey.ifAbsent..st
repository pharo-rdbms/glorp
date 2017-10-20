caching
removeKey: key ifAbsent: errorBlock
	"Note: The key is NOT removed from keysSortedByExpiryTime. The reaper
	will eventually reap the given key, and ignore it since it is already gone.
	Removing objects from the middle of keysSortedByExpiryTime will screw
	up the indexing of objects that are registered later. Don't do it."

	| result |
	[mutex wait.
	result := weakValueDictionary removeKey: key ifAbsent: [^errorBlock value]]
		ensure: [mutex signal].
	^result.