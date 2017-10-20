tests-simple reference classes
testSimpleTypeOneToManyComplexQuerying
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each titles sqlCount = 3].
	self assert: publishers size = 1.
	self assert: publishers first titles size = 3.
	self assert: (publishers first titles includes: 'Mastering ENVY/Developer').