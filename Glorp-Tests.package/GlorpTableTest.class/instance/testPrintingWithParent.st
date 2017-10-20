tests
testPrintingWithParent

	| t t1 |
	t := system tableNamed: 'GR_CUSTOMER'.
	t1 := t copy.
	t1 parent: t.
	t1 name: 'foo'.
	self assert: t1 sqlTableName = 'GR_CUSTOMER foo'.