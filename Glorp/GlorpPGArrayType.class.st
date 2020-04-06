Class {
	#name : #GlorpPGArrayType,
	#superclass : #GlorpAbstractStringType,
	#category : #'Glorp-Types'
}

{ #category : #initialize }
GlorpPGArrayType >> initialize [
	super initialize.
	typeString := 'ARRAY'.
]

{ #category : #testing }
GlorpPGArrayType >> isVariableWidth [
	^true
]
