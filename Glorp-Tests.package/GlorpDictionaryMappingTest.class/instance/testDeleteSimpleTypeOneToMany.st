tests-simple reference classes
testDeleteSimpleTypeOneToMany
	| publishers publisher |
	self assert: (session read: GlorpPublisher) isEmpty.
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	session modify: publisher in: [
		publisher titles: (publisher titles copyWithout: 'Mastering ENVY/Developer')].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	self assert: publisher titles size = 2.
	self assert: publisher titles asSortedCollection = (session system examplePublisher1 titles copyWithout: 'Mastering ENVY/Developer') asSortedCollection.