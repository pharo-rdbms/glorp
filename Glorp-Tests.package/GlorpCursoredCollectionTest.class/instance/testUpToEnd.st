tests
testUpToEnd
	| people |
	people := stream upToEnd.
	self assert: people size = 3.
	self assert: people first name = 'Alan'.
	self assert: people last name = 'Carol'.