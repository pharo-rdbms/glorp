tests
testNext
	| person |
	person := stream next.
	self assert: person class == GlorpPerson.
	self assert: person id = 1.
	self assert: person name = 'Alan'.
	self assert: session privateGetCache numberOfElements = 1.
	person := stream next.
	self assert: person id = 2.
	self assert: person name = 'Bob'.
	self assert: session privateGetCache numberOfElements = 2.
	stream next.
	self assert: stream atEnd.
	self assert: stream next = nil.