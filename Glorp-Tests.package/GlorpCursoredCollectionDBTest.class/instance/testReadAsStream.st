tests
testReadAsStream
	| query stream person restOfPeople |
	query := Query read: GlorpPerson.
	query orderBy: [:each | each id].
	query collectionType: GlorpCursoredStream.
	stream := session execute: query.
	self assert: session privateGetCache numberOfElements = 0.
	person := stream next.
	self assert: session privateGetCache numberOfElements = 1.
	self assert: person id = 86.
	restOfPeople := stream upToEnd.
	self assert: restOfPeople size = 2.
	self assert: session privateGetCache numberOfElements = 3.