tests-simple reference dictionary
testSimpleTypeDictionaryComplexQuerying
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each titlesWithNumberInStock sqlCount = 3].
	self assert: publishers size = 1.
	self assert: publishers first titlesWithNumberInStock size = 3.
	self assert: (publishers first titlesWithNumberInStock keys includes: 'Mastering ENVY/Developer').

"	publishers := session read: GlorpPublisher where: [:each | each titlesWithNumberInStockLink sqlCount > 0].
	publishers := publishers asSortedCollection: [:a :b | a name <= b name].
	self assert: publishers size = 2.
	self assert: publishers first titlesWithNumberInStock size = 3.
	self assert: (publishers first titlesWithNumberInStock keys includes: 'Mastering ENVY/Developer')."