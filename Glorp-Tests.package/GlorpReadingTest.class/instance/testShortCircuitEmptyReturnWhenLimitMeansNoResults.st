tests
testShortCircuitEmptyReturnWhenLimitMeansNoResults
	self deny: (SimpleQuery read: GlorpAddress limit: 3) shortCircuitEmptyReturn.
	self assert: (SimpleQuery read: GlorpAddress limit: 0) shortCircuitEmptyReturn.
	self assert: (SimpleQuery read: GlorpAddress limit: -3) shortCircuitEmptyReturn