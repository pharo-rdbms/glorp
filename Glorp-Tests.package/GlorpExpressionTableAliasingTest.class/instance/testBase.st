tests
testBase
	exp := BaseExpression new.
	exp descriptor: (system descriptorFor: GlorpCustomer).
	self helpTestBasicAliasing: (system tableNamed: 'GR_CUSTOMER').