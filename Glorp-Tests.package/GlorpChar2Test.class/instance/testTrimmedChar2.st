tests
testTrimmedChar2
	| converter |
	stType := String.
	converter := type platform converterNamed: #stringToTrimmedString.
	self assert: (converter convert:  'abc' toDatabaseRepresentationAs: type) = 'ab'.
	self assert: (converter convert:  'abcd' toDatabaseRepresentationAs: type) = 'ab'.
	self assert: (converter convert:  'abcde' toDatabaseRepresentationAs: type) = 'ab'.