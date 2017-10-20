tests-simple reference dictionary
testUpdateSimpleTypeDictionaryLinkedDeleting
"	| publishers publisher |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	session modify: publisher in: [
		publisher titlesWithNumberInStockLink removeKey: 'Mastering ENVY/Developer'].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	self assert: (publisher titlesWithNumberInStockLink at: 'Mastering ENVY/Developer' ifAbsent: [999]) = 999.
	self assert: publisher titlesWithNumberInStockLink size = 2."