tests
testLikeUnderscore
	self deny: ('' like: '_').
	self assert: ('a' like: '_').
	self assert: ('abc' like: '_bc').
	self deny: ('aaababc' like: '_bc').
	self deny: ('abcd' like: 'ab_cd').
	self assert: ('abcd' like: 'a_cd').
	self assert: ('abcdef' like: 'ab__ef').
	self assert: ('abcdef' like: 'ab__ef%').
	self assert: ('abcdefg' like: 'ab%ef_').
	self deny: ('abcdefgh' like: 'ab%ef_').