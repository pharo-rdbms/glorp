accessing
keyDictionary
	keyDictionary isNil ifTrue: [ self buildKeyDictionary ].
	^keyDictionary