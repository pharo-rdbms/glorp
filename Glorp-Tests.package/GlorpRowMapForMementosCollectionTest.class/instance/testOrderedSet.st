tests
testOrderedSet
	collection := (Dialect smalltalkAt: #OrderedSet ifAbsent: [^self]) new.
	1 to: 50 do: [:i | collection add: i].
	copy := collection copy.
	transaction register: collection.
	#( 1 2 7 43 15 9 10 17 18 19 33 23) do: [:i | collection remove: i].
	collection add: 999.
	self createRowMap.
	self assert: newCollection asSortedCollection = copy asSortedCollection.
	self deny: newCollection asSortedCollection = collection asSortedCollection
		description: 'Copying is too shallow both here and in registerTransientInternalsOfCollection:'.