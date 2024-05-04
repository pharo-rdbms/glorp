"
Character type
"
Class {
	#name : 'GlorpCharType',
	#superclass : 'GlorpAbstractStringType',
	#category : 'Glorp-Types',
	#package : 'Glorp',
	#tag : 'Types'
}

{ #category : 'initialization' }
GlorpCharType >> initialize [
	super initialize.
	typeString := 'char'.
]

{ #category : 'testing' }
GlorpCharType >> isVariableWidth [
	^false.
]

{ #category : 'accessing' }
GlorpCharType >> typeString [

	^self typeName, '(', width printString, ')'.
]
