tests-simple reference classes
testUpdateSimpleTypeOneToMany
	| publishers publisher |
	self assert: (session read: GlorpPublisher) isEmpty.
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	session modify: publisher in: [
		publisher titles: (Array with: 'New Improved Book'), publisher titles].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	self assert: publisher titles size = 4.
	self assert: publisher titles asSortedCollection = (session system examplePublisher1 titles , (Array with: 'New Improved Book')) asSortedCollection.