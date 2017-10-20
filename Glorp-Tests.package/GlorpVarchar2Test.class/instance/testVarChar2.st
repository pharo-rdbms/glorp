tests
testVarChar2
	self platform isUDBCSQLite3Platform ifTrue: [ ^ self skip. ].
	stType := String.
	self helpTestValue: nil.
	self helpTestValue: '' compareWith: [:read :original |
		self platform usesNullForEmptyStrings ifTrue: [read = nil] ifFalse: [read = original]].
	self helpTestValue: 'a'.
	self helpTestValue: 'ab'.

	self platform autoTrimsStringsLongerThanColumnSize ifFalse: [ 
		self should: [self helpTestInvalidValue: 'abc'] raise: GlorpDatabaseWriteError.
		self should: [self helpTestInvalidValue: 'abcd'] raise: GlorpDatabaseWriteError.
		self should: [self helpTestInvalidValue: 'abcde'] raise: GlorpDatabaseWriteError.
	]