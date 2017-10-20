support
exampleTransactionsProxy
	| p |
	p := Proxy new.
	p session: session.
	p query: (GlorpQueryStub readOneOf: GlorpBankTransaction where: [:a | a id ~= 0]).
	p query result: (Array with: GlorpBankTransaction example1 with: GlorpBankTransaction example1).
	^p