tests
testPrintingWithoutParent

	| t t1 |
	t := system tableNamed: 'GR_CUSTOMER'.
	self assert: t sqlTableName = 'GR_CUSTOMER'.