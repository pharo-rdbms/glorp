"
Text type
"
Class {
	#name : #GlorpTextType,
	#superclass : #GlorpAbstractStringType,
	#category : 'Glorp-Types'
}

{ #category : #initialize }
GlorpTextType >> initialize [
	super initialize.
	typeString := 'text'.
]

{ #category : #testing }
GlorpTextType >> isVariableWidth [
	^true.
]
