tests
testKnittingWithAlsoFetchToManyInSingleGroup
	| query person1 |
	query := Query read: GlorpPerson.
	query session: session.
	query alsoFetch: [:each | each emailAddresses].
	query prepare.
	stream := GlorpCursoredStream on: self joinedStreamToMany for: (query sqlWith: #()).
	person1 := stream next.
	self assert: session privateGetCache numberOfElements = 3.
	self assert: (person1 emailAddresses allSatisfy: [:each | each user = 'root']).
	self assert: person1 emailAddresses first ~= person1 emailAddresses last.
	self assert: stream atEnd.