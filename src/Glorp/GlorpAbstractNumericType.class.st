"
Abstract numeric type
"
Class {
	#name : 'GlorpAbstractNumericType',
	#superclass : 'GlorpDatabaseType',
	#category : 'Glorp-Types',
	#package : 'Glorp',
	#tag : 'Types'
}

{ #category : 'testing' }
GlorpAbstractNumericType class >> isAbstract [

	^ self == GlorpAbstractNumericType
]

{ #category : 'converting' }
GlorpAbstractNumericType >> impliedSmalltalkType [
	^Number.
]
