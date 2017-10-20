tests-simple reference dictionary
testUpdateSimpleTypeDictionaryModifying
	| publishers publisher |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	session modify: publisher in: [
		publisher titlesWithNumberInStock at: 'Mastering ENVY/Developer' put: 123].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	self assert: (publisher titlesWithNumberInStock at: 'Mastering ENVY/Developer') = 123.