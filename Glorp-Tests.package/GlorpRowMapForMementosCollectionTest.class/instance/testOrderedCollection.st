tests
testOrderedCollection
	collection := (1 to: 50) asOrderedCollection.
	copy := collection copy.
	transaction register: collection.
	12 timesRepeat: [collection removeLast].
	collection at: 3 put: 'hello'.
	self createRowMap.
	self assert: newCollection = copy.
	self deny: newCollection = collection
		description: 'Copying is too shallow both here and in registerTransientInternalsOfCollection:'.