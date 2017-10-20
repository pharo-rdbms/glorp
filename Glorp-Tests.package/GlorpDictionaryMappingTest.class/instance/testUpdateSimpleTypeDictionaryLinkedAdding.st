tests-simple reference dictionary
testUpdateSimpleTypeDictionaryLinkedAdding
"	| publishers publisher |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	session modify: publisher in: [
		publisher titlesWithNumberInStockLink at: 'New Book' put: 1].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	self assert: (publisher titlesWithNumberInStockLink at: 'New Book') = 1.
	self assert: publisher titlesWithNumberInStockLink size = 4."