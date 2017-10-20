initializing
initialize

	done := false.
	self delay: 5. "seconds"
	self maximumWork: 100. "milliseconds"
	nextId := 1.
	weakValueDictionary := Dialect weakValueDictionaryClass new.
	weakValueDictionary manager: self.

	"Note: The sort used by keysSortedByExpiryTime _must_ be stable."
	keysSortedByExpiryTime := SortedCollection sortBlock: [:associationA :associationB | associationA value "timeToDie" <= associationB value].

	indexOffset := 0.
	mutex := Semaphore forMutualExclusion.
	self forkReaperThread