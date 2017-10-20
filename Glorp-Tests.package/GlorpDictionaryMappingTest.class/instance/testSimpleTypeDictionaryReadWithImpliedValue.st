tests-simple reference dictionary
testSimpleTypeDictionaryReadWithImpliedValue
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each titlesWithNumberInStock anySatisfy: [:eachTitleAssociation |
		eachTitleAssociation = 2]].
	self assert: publishers size = 1.