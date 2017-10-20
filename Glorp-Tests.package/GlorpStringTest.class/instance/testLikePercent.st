tests
testLikePercent
	self deny: ('abc' like: 'def').
	self assert: ('' like: '%').
	self assert: ('abc' like: '%').
	self assert: ('abc' like: '%bc').
	self deny: ('abc' like: 'a%ac').
	self assert: ('aaababc' like: '%bc').
	self assert: ('abcd' like: 'ab%cd').
	self assert: ('abcdef' like: 'ab%ef').
	self assert: ('abcdef' like: 'ab%ef%').
	self assert: ('abcdefg' like: 'ab%ef%').