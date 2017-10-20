tests
testComputingFieldsForDirectMappingsWithFullPrepare

	| query table |
	query := Query readOneOf: GlorpAddress where: [:each | each id = 1].
	query session: session.
	query prepare.
	
	table := session system tableNamed: 'GR_ADDRESS'.
	self assert: ((query fields collect: [:each | each table parent fieldNamed: each name])= table fields).