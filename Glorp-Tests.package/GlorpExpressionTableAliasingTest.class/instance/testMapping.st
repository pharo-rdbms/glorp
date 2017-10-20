tests
testMapping
	| base |
	base := BaseExpression new.
	base descriptor: (system descriptorFor: GlorpCustomer).
	exp := base get: 'transactions'.
	self helpTestBasicAliasing: (system tableNamed: 'BANK_TRANS').