tests
testLikePercentButNotStar
	self deny: ('abcd' like: 'abc*').
	self deny: ('abcdefgh' like: 'ab%e*gh').
	self assert: ('abcdefgh' like: 'ab%efgh').
	self assert: ('abc*efg' like: 'abc*efg').
	self assert: ('abc*efg' like: 'ab%g').
	self assert: ('abc*efg' like: 'abc_efg').