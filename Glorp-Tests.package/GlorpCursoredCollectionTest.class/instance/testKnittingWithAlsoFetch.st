tests
testKnittingWithAlsoFetch
	| query person1 person2 |
	query := Query read: GlorpPerson.
	query session: session.
	query alsoFetch: [:each | each address].
	query prepare.
	stream := GlorpCursoredStream on: self joinedStream2 for: (query sqlWith: nil).
	person1 := stream next.
	self assert: session privateGetCache numberOfElements = 2.
	self assert: person1 address street = '1st Avenue'.
	person2 := stream next.
	self assert: session privateGetCache numberOfElements = 4.
	self assert: stream atEnd.
	self assert: person2 id = 2.
	self assert: person2 address street = '2nd Avenue'.
	self assert: session privateGetCache numberOfElements = 4.