tests
testComputingFieldsForDirectMappings

	| query table |
	query := SimpleQuery readOneOf: GlorpAddress where: [:each | each id = 1].
	self setUpQueryFields: query.
	
	table := session system tableNamed: 'GR_ADDRESS'.
	self assert: (query fields = table fields).