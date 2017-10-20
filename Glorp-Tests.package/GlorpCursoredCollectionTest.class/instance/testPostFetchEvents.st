tests
testPostFetchEvents
	| query customer |
	query := Query read: GlorpCustomer.
	query session: session.
	query prepare.
	stream := GlorpCursoredStream on: self customerStream for: (query sqlWith: #()).
	customer := stream next.
	self assert: customer seenPostFetch.