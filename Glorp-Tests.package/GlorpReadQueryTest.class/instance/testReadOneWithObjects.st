tests-data reading
testReadOneWithObjects

	| query result |
	query := Query readOneOf: GlorpPerson where: [:each | each id = 86].
	query retrieve: [:each | each].
	query retrieve: [:each | each address].
	query orderBy: [:each | each id].
	result := query executeIn: session.
	self assert: result first id = 86.
	self assert: (result first address yourSelf == result last).