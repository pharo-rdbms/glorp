support
exampleCustomerProxy
	| p |
	p := Proxy new.
	p session: session.
	p query: (GlorpQueryStub readOneOf: GlorpCustomer where: [:a | a id = 3]).
	p query result: (GlorpCustomer new id: 3).
	^p