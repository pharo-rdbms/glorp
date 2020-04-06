Class {
	#name : #GlorpChar2Test,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : 'Glorp-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpChar2Test >> defaultDatabaseType [
	^self platform char width: 2
]

{ #category : #tests }
GlorpChar2Test >> testChar2 [
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
	 ].
	
	self assert: (type typeString asUppercase = (self platform char: 2) typeString asUppercase)
]

{ #category : #tests }
GlorpChar2Test >> testTrimmedChar2 [
	| converter |
	stType := String.
	converter := type platform converterNamed: #stringToTrimmedString.
	self assert: (converter convert:  'abc' toDatabaseRepresentationAs: type) = 'ab'.
	self assert: (converter convert:  'abcd' toDatabaseRepresentationAs: type) = 'ab'.
	self assert: (converter convert:  'abcde' toDatabaseRepresentationAs: type) = 'ab'.
]
