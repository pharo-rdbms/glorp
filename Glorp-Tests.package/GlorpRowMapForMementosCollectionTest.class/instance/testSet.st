tests
testSet
	collection := (1 to: 50) asSet.
	copy := collection copy.
	transaction register: collection.
	1 to: 12 do: [:i | collection remove: i].
	collection add: 'hello'.
	self createRowMap.
	self assert: newCollection asSortedCollection = copy asSortedCollection.
	self deny: newCollection size = collection size
		description: 'Copying is too shallow both here and in registerTransientInternalsOfCollection:'.