support
setUp
	| query |
	super setUp.
	session := GlorpSessionResource current newSession.
	((session descriptorFor: GlorpCustomer) mappingForAttributeNamed: #name) shouldProxy: false.
	query := Query read: GlorpPerson.
	query session: session.
	query prepare.
	stream := GlorpCursoredStream on: self mockStream for: (query sqlWith: nil) accessor: nil.