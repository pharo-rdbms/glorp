tests-simple reference dictionary
testSimpleTypeDictionary
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each id = 1].
	publishers do: [:each | 
		each titlesWithNumberInStock keysAndValuesDo: [:eachTitle :eachNumber | 	
			self assert: eachTitle isString.
			self assert: eachNumber = 2]].
	self assert: publishers first titlesWithNumberInStock size = 3.
	self assert: publishers first titlesWithNumberInStock keys asSortedCollection = session system examplePublisher1 titles asSortedCollection.

"	publishers do: [:each | 
		each titlesWithNumberInStockLink keysAndValuesDo: [:eachTitle :eachNumber | 	
			self assert: eachTitle isString.
			self assert: eachNumber = 2]].
	self assert: publishers first titlesWithNumberInStockLink size = 3.
	self assert: publishers first titlesWithNumberInStockLink keys asSortedCollection = session system examplePublisher1 titles asSortedCollection."