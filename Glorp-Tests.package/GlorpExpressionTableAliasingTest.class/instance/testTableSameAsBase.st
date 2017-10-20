tests
testTableSameAsBase
	| base custTable |
	base := BaseExpression new.
	base descriptor: (system descriptorFor: GlorpCustomer).
	custTable := system tableNamed: 'GR_CUSTOMER'.
	exp := base getTable: custTable.
	self deny: exp hasTableAliases.
	exp assignTableAliasesStartingAt: 1 prefix: ''.
	base assignTableAliasesStartingAt: 42 prefix: nil.
	self deny: exp hasTableAliases.
	self assert: (exp aliasedTableFor: custTable) name = 't42'.