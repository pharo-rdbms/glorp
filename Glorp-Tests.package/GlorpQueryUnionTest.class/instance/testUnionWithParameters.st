tests-functional
testUnionWithParameters
	| query1 query2 union result field1 dict |
	field1 := (system tableNamed: 'GR_ADDRESS') fieldNamed: 'ID'.
	query1 := Query read: GlorpAddress where: [:each | each id = (each parameter: field1)].
	query2 := Query read: GlorpAddress where: [:each | each id = ((each parameter: field1) + 1)].	
	union := query1 unionAll: query2.
	union orderBy: [:each | each id].
	dict := Dictionary new at: field1 put: 2; yourself.
	result := union executeWithParameters: dict in: session.
	self assert: result size = 2.
	self assert: result first id = 2.
	self assert: result last id = 3.
	self assert: (result allSatisfy: [:each | each class == GlorpAddress]).