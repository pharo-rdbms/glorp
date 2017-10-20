tests
testRBSmallDictionary
	collection := (Dialect smalltalkAt: #RBSmallDictionary ifAbsent: [^self]) new.
	1 to: 50 do: [:i | collection at: i put: i printString].
	copy := collection copy.
	transaction register: collection.
	#( 1 2 7 43 15 9 10 17 18 19 33 23) do: [:i | collection removeKey: i].
	collection at: 3 put: 'hello'.
	self createRowMap.
	self assert: newCollection size = copy size.
	self assert: newCollection keys asSortedCollection = copy keys asSortedCollection.
	self assert: newCollection values asSortedCollection = copy values asSortedCollection.
	self deny: newCollection values asSortedCollection = collection values asSortedCollection
		description: 'Copying is too shallow both here and in registerTransientInternalsOfCollection:'.