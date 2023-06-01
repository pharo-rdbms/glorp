"
Text type
"
Class {
	#name : #GlorpTextType,
	#superclass : #GlorpAbstractStringType,
	#category : #'Glorp-Types'
}

{ #category : #initialization }
GlorpTextType >> initialize [
	super initialize.
	typeString := 'text'.
]

{ #category : #testing }
GlorpTextType >> isVariableWidth [
	^true.
]
