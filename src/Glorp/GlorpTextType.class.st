"
Text type
"
Class {
	#name : 'GlorpTextType',
	#superclass : 'GlorpAbstractStringType',
	#category : 'Glorp-Types',
	#package : 'Glorp',
	#tag : 'Types'
}

{ #category : 'initialization' }
GlorpTextType >> initialize [
	super initialize.
	typeString := 'text'.
]

{ #category : 'testing' }
GlorpTextType >> isVariableWidth [
	^true.
]
