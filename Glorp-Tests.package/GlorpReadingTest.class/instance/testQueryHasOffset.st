tests
testQueryHasOffset
	self deny: (SimpleQuery read: GlorpAddress) hasOffset.
	self assert: ((SimpleQuery read: GlorpAddress) offset: 10; yourself) hasOffset.
	self deny: ((SimpleQuery read: GlorpAddress) offset: 0; yourself) hasOffset.
	self deny: ((SimpleQuery read: GlorpAddress) offset: -10; yourself) hasOffset.