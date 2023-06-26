"
Test string extensions in Glorp.
"
Class {
	#name : #GlorpStringTest,
	#superclass : #GlorpTestCase,
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #tests }
GlorpStringTest >> testGlorpIsCollection [

	self deny: 'abc' glorpIsCollection.
	self deny: Object new glorpIsCollection.
	self deny: $a glorpIsCollection.
	self assert: #() glorpIsCollection
]

{ #category : #tests }
GlorpStringTest >> testLikePercent [

	self deny: ('abc' like: 'def').
	self assert: ('' like: '%').
	self assert: ('abc' like: '%').
	self assert: ('abc' like: '%bc').
	self deny: ('abc' like: 'a%ac').
	self assert: ('aaababc' like: '%bc').
	self assert: ('abcd' like: 'ab%cd').
	self assert: ('abcdef' like: 'ab%ef').
	self assert: ('abcdef' like: 'ab%ef%').
	self assert: ('abcdefg' like: 'ab%ef%')
]

{ #category : #tests }
GlorpStringTest >> testLikePercentButNotStar [

	self deny: ('abcd' like: 'abc*').
	self deny: ('abcdefgh' like: 'ab%e*gh').
	self assert: ('abcdefgh' like: 'ab%efgh').
	self assert: ('abc*efg' like: 'abc*efg').
	self assert: ('abc*efg' like: 'ab%g').
	self assert: ('abc*efg' like: 'abc_efg')
]

{ #category : #tests }
GlorpStringTest >> testLikeUnderscore [

	self deny: ('' like: '_').
	self assert: ('a' like: '_').
	self assert: ('abc' like: '_bc').
	self deny: ('aaababc' like: '_bc').
	self deny: ('abcd' like: 'ab_cd').
	self assert: ('abcd' like: 'a_cd').
	self assert: ('abcdef' like: 'ab__ef').
	self assert: ('abcdef' like: 'ab__ef%').
	self assert: ('abcdefg' like: 'ab%ef_').
	self deny: ('abcdefgh' like: 'ab%ef_')
]

{ #category : #tests }
GlorpStringTest >> testLikeUnderscoreButNotHash [

	self deny: ('a' like: '#').
	self assert: ('a##b' like: 'a##b').
	self assert: ('a#bcd' like: 'a#_cd')
]
