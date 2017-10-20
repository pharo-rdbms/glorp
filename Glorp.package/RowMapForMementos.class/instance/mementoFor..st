api
mementoFor: aKey
	^(self isRowMapKey: aKey)
		ifTrue: [aKey adjustIn: correspondenceMap]
		ifFalse: [correspondenceMap at: aKey ifAbsent: [aKey]]