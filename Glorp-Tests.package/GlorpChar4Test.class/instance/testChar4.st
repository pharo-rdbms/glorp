tests
testChar4

	self platform isUDBCSQLite3Platform ifTrue: [ self skip ].

	stType := String.
	self helpTestValue: nil.
	self helpTestValue: '' compareWith: [:read :original |
		self platform usesNullForEmptyStrings ifTrue: [read = nil] ifFalse: [read = original]].
	self helpTestValue: 'a'.
	self helpTestValue: 'ab'.
	self helpTestValue: 'abc'.
	self helpTestValue: 'abcd'.
	self platform autoTrimsStringsLongerThanColumnSize ifFalse: [ 
		self should: [self helpTestInvalidValue: 'abcde'] raise: GlorpDatabaseWriteError.
	].
	stType := Symbol.

	"This overlong-means-invalid check fails on SQLite where column length limits are unenforced."
	self helpTestValue: #abcd.
	
	self assert: (type typeString asUppercase= (self platform char: 4) typeString asUppercase)