tests
testReadLiteralEmptyStream
	| query stream person |
	query := Query read: GlorpPerson where: false.
	query collectionType: GlorpCursoredStream.
	stream := session execute: query.
	self assert: session privateGetCache numberOfElements = 0.
	person := stream next.
	self assert: session privateGetCache numberOfElements = 0.
	self assert: person isNil.
	self assert: stream atEnd.