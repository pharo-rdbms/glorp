tests-simple reference classes
testSimpleTypeOneToMany
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each id = 1].
	publishers do: [:each | 
		each titles do: [:eachTitle | self assert: eachTitle isString]].
	self assert: publishers first titles size = 3.
	self assert: publishers first titles asSortedCollection = session system examplePublisher1 titles asSortedCollection.