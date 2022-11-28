"
CLOB type
"
Class {
	#name : #GlorpClobType,
	#superclass : #GlorpAbstractStringType,
	#category : 'Glorp-Types'
}

{ #category : #testing }
GlorpClobType >> hasParameters [
	"Return true if this has modifiable parameters. That is, when we return one of these, should we return a copy rather than trying to save space be re-using instances"
	^false.
]

{ #category : #initialize }
GlorpClobType >> initialize [
	super initialize.
	typeString := 'text'.
	width := nil.
]

{ #category : #testing }
GlorpClobType >> isVariableWidth [
	^true.
]

{ #category : #testing }
GlorpClobType >> requiresCast [
	^(self platform class = PostgreSQLPlatform) or: [self platform class = SQLServerPlatform]
]
