tests
testComputingFieldsForReferenceMappings

	| query table |
	query := SimpleQuery readOneOf: GlorpPerson where: [:each | each id = 1].
	self setUpQueryFields: query.
	
	table := session system tableNamed: 'PERSON'.
	self assert: (query fields = table fields).