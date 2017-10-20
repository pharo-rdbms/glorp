tests
testFieldBuiltOnDifferentTable
	| result custTable |
	custTable := system tableNamed: 'GR_CUSTOMER'.
	result := self 
		resultOfJoiningFieldFor: custTable
		toExpressionBuiltOn: custTable.
	self assert: result base == (base getTable: custTable).
	self assert: result field == ((system tableNamed: 'GR_CUSTOMER') fieldNamed: 'ID').