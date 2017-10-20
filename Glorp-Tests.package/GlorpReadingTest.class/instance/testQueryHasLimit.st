tests
testQueryHasLimit
	self deny: (SimpleQuery read: GlorpAddress) hasLimit.
	self assert: (SimpleQuery read: GlorpAddress limit: 10) hasLimit.
	self assert: (SimpleQuery read: GlorpAddress limit: -10) hasLimit.

	self assert: (SimpleQuery read: GlorpAddress) limitMakesSense.
	self assert: (SimpleQuery read: GlorpAddress limit: 10) limitMakesSense.
	self deny: (SimpleQuery read: GlorpAddress limit: 0) limitMakesSense.
	self deny: (SimpleQuery read: GlorpAddress limit: -10) limitMakesSense.