tests-simple reference classes
testSimpleTypeOneToManyQueryingIncludes
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each titles includes: 'Mastering ENVY/Developer' ].
	self assert: publishers size = 1.
	self assert: (publishers first titles includes: 'Mastering ENVY/Developer').