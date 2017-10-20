tests-simple reference dictionary
testSimpleTypeDictionaryQuerying
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.

	publishers := session read: GlorpPublisher where: [:each | each titlesWithNumberInStock anySatisfy: [:x | x key like: 'Master%']].
	self assert: publishers size = 1.
	self assert: publishers first titlesWithNumberInStock size = 3.
	self assert: (publishers first titlesWithNumberInStock keys includes: 'Mastering ENVY/Developer').

"	publishers := session read: GlorpPublisher where: [:each | each titlesWithNumberInStock anySatisfy: [:x | x value  = 2]].
	self assert: publishers size = 1.
	self assert: publishers first id = 1."