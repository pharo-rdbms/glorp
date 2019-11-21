Class {
	#name : #GlorpVarchar2Test,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : 'Glorp-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpVarchar2Test >> defaultDatabaseType [
	^self platform varchar: 2.
]

{ #category : #tests }
GlorpVarchar2Test >> testTrimmedChar2 [
	| converter |
	stType := String.
	converter := type platform converterNamed: #stringToTrimmedString.
	self assert: (converter convert:  'abc' toDatabaseRepresentationAs: type) = 'ab'.
	self assert: (converter convert:  'abcd' toDatabaseRepresentationAs: type) = 'ab'.
	self assert: (converter convert:  'abcde' toDatabaseRepresentationAs: type) = 'ab'.
]

{ #category : #tests }
GlorpVarchar2Test >> testVarChar2 [
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
]
