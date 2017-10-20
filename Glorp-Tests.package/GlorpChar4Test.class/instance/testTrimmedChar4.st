tests
testTrimmedChar4
	| converter |
	stType := String.
	converter := type platform converterNamed: #stringToTrimmedString.
	self assert: (converter convert:  'abc' toDatabaseRepresentationAs: type)
					= ('abc', (Array with: type platform paddingCharacter)).
	self assert: (converter convert:  'abcd' toDatabaseRepresentationAs: type) = 'abcd'.
	self assert: (converter convert:  'abcde' toDatabaseRepresentationAs: type) = 'abcd'.