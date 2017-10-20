tests
testArray
	collection := Array with: 1 with: 2 with: 3 with: 4.
	copy := collection copy.
	transaction register: collection.
	collection at: 3 put: 'hello'.
	self createRowMap.
	self assert: newCollection = copy.
	self deny: newCollection = collection
		description: 'Copying is too shallow both here and in registerTransientInternalsOfCollection:'.