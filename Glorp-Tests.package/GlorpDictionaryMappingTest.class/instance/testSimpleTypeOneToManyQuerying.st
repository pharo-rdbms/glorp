tests-simple reference classes
testSimpleTypeOneToManyQuerying
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each titles anySatisfy: [:x | x like: 'Master%' ]].
	self assert: publishers size = 1.
	self assert: (publishers first titles anySatisfy: [:each | each like: 'Master%']).