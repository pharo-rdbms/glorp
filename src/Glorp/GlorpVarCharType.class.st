"
VARCHAR type
"
Class {
	#name : #GlorpVarCharType,
	#superclass : #GlorpAbstractStringType,
	#category : 'Glorp-Types'
}

{ #category : #initialize }
GlorpVarCharType >> initialize [
	super initialize.
	typeString := 'varchar'.
]

{ #category : #testing }
GlorpVarCharType >> isVariableWidth [
	"Return true if this type allows varying length data within a particular instance. e.g., this is true for a varchar, but false for a fixed size character field"
	^true.
]

{ #category : #accessing }
GlorpVarCharType >> typeString [
	
	^self typeName,   ( width ifNil: [''] ifNotNil: [ :w |'(', w printString, ')'])
]
