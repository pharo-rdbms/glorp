tests
testNextColon
	| people |
	people := stream next: 2.
	self assert: people size = 2.
	self assert: people first id = 1.
	self assert: people first name = 'Alan'.
	self assert: session privateGetCache numberOfElements = 2.
	self assert: people last id = 2.