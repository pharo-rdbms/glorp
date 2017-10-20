tests
testKnittingWithRetrieve
	| query tuple person1 address1 person2 address2 |
	query := Query read: GlorpPerson.
	query session: session.
	query retrieve: [:each | each].
	query retrieve: [:each | each address].
	query prepare.
	stream := GlorpCursoredStream on: self joinedStream for: (query sqlWith: nil).
	tuple := stream next.
	self assert: session privateGetCache numberOfElements = 2.
	person1 := tuple first.
	address1 := tuple last.
	self assert: address1 street = '1st Avenue'.
	self assert: person1 address == address1.
	tuple := stream next.
	self assert: stream atEnd.
	person2 := tuple first.
	address2 := tuple last.
	self assert: person2 id = 2.
	self assert: address2 street = '2nd Avenue'.
	self assert: person2 address == address2.