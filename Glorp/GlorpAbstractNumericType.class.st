"
Abstract numeric type
"
Class {
	#name : #GlorpAbstractNumericType,
	#superclass : #GlorpDatabaseType,
	#category : 'Glorp-Types'
}

{ #category : #converting }
GlorpAbstractNumericType >> impliedSmalltalkType [
	^Number.
]
