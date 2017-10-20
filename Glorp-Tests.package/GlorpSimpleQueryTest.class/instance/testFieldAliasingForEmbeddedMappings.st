tests
testFieldAliasingForEmbeddedMappings

	| query table |
	query := SimpleQuery readOneOf: GlorpBankTransaction where: [:each | each id = 1].
	self setUpQueryFields: query.
	table := session system tableNamed: 'BANK_TRANS'.
	self assert: (query fields = table fields).
	self assert: (query builders first translateFieldPosition: (table fieldNamed: 'ID')) = 1.
	self assert: (query builders first translateFieldPosition: (table fieldNamed: 'OWNER_ID')) = 2.