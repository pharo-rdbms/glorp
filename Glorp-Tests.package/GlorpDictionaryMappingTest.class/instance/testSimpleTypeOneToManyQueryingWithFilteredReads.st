tests-simple reference classes
testSimpleTypeOneToManyQueryingWithFilteredReads
	| publishers publisherOne publisher2 |
	((session system descriptorFor: GlorpPublisher) mappingForAttributeNamed: #titles) useFilteredRead.
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each id < 3].
	self assert: publishers size = 2.
	publisherOne := publishers detect: [:each | each id = 1].
	self assert: publisherOne titles size = 3.
	self assert: (publisherOne titles includes: 'Mastering ENVY/Developer').
	session accessor denyReads.
	publisher2 := publishers detect: [:each | each id = 2].
	self assert: publisher2 titles first = 'A book'.