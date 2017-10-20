tests
testComputingFieldsForReferenceMappingsWithFullPrepare

	| query table |
	query := SimpleQuery readOneOf: GlorpPerson where: [:each | each id = 1].
	query session: session.
	query prepare.
	
	table := session system tableNamed: 'PERSON'.
	self assert: ((query fields collect: [:each | each table parent fieldNamed: each name])= table fields).