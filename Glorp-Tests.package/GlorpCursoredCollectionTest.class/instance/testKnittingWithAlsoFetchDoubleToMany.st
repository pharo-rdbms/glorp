tests
testKnittingWithAlsoFetchDoubleToMany
	| query customer1 |
	query := Query read: GlorpCustomer.
	query session: session.
	query alsoFetch: [:each | each accounts].
	query alsoFetch: [:each | each transactions].
	query prepare.
	stream := GlorpCursoredStream on: self joinedStreamToMany3 for: (query sqlWith: #()).
	customer1 := stream next.
	self assert: session privateGetCache numberOfElements = 7.
	self assert: stream atEnd.
	self assert: customer1 id = 1.
	self assert: customer1 accounts size = 2.
	self assert: customer1 accounts first accountNumber accountNumber = '123'.
	self assert: customer1 accounts last accountNumber accountNumber = '234'.