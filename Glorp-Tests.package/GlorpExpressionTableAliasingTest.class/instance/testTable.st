tests
testTable
	| base transTable |
	base := BaseExpression new.
	base descriptor: (system descriptorFor: GlorpCustomer).
	transTable := system tableNamed: 'BANK_TRANS'.
	exp := base getTable: transTable.
	self helpTestBasicAliasing: transTable