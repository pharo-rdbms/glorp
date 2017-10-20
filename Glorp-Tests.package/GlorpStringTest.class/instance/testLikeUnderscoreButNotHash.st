tests
testLikeUnderscoreButNotHash
	self deny: ('a' like: '#').
	self assert: ('a##b' like: 'a##b').
	self assert: ('a#bcd' like: 'a#_cd').