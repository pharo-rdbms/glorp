"
Abstract superclass for string types

Instance Variables
	queryType:		<Object>
	width:		<Object>

queryType
	- xxxxx

width
	- xxxxx

"
Class {
	#name : #GlorpAbstractStringType,
	#superclass : #GlorpDatabaseType,
	#instVars : [
		'width',
		'queryType'
	],
	#category : 'Glorp-Types'
}

{ #category : #comparing }
GlorpAbstractStringType >> = aType [
	super = aType ifFalse: [^false].
	self width = aType width ifFalse: [^false].
	self queryType == self ifFalse: [
		self queryType = aType queryType ifFalse: [^false]].
	^true.
]

{ #category : #converting }
GlorpAbstractStringType >> converterForStType: aClass [
	(aClass includesBehavior: Boolean) ifTrue: [^self platform converterNamed: #booleanToStringTF].
	(aClass includesBehavior: Symbol) ifTrue: [^self platform converterNamed: #symbolToString].
	width isNil ifFalse: [
		(aClass includesBehavior: String) ifTrue: [^self platform converterNamed: #stringToString]].
	(aClass includesBehavior: Integer) ifTrue: [^self platform converterNamed: #integerToString].
	^super converterForStType: aClass.
]

{ #category : #testing }
GlorpAbstractStringType >> hasParameters [
	"Return true if this has modifiable parameters. That is, when we return one of these, should we return a copy rather than trying to save space be re-using instances"
	^true.
]

{ #category : #testing }
GlorpAbstractStringType >> hasWidth [
	"Return true if this type has a width attribute - basically meaning it's a string or LOB type. Note that this is different from the isVariableWidth test, which tells us if a field has fixed vs. varying width. So a CHAR field hasWidth=>true, but isVariableWidth=>false, while a VARCHAR field hasWidth=>true isVariableWidth=>false, and a NUMBER has both false."
	^true.
]

{ #category : #comparing }
GlorpAbstractStringType >> hash [
	^self queryType == self
		ifTrue: [super hash bitXor: self width hash]
		ifFalse: [(super hash bitXor: self width hash) bitXor: self queryType hash]
]

{ #category : #converting }
GlorpAbstractStringType >> impliedSmalltalkType [
	^String.
]

{ #category : #testing }
GlorpAbstractStringType >> isStringType [
	^true.
]

{ #category : #testing }
GlorpAbstractStringType >> isVariableWidth [
	self subclassResponsibility.
]

{ #category : #accessing }
GlorpAbstractStringType >> queryType [
	queryType isNil ifTrue: [^self].
	^queryType.
]

{ #category : #accessing }
GlorpAbstractStringType >> queryType: aType [
	queryType := aType
]

{ #category : #private }
GlorpAbstractStringType >> typeName [
	^typeString.
]

{ #category : #private }
GlorpAbstractStringType >> typeName: aString [
	typeString := aString.
]

{ #category : #SQL }
GlorpAbstractStringType >> typeString [
	typeString isNil
		ifTrue:
			[typeString := self typeName.
			width isNil
				ifFalse: [typeString := typeString , '(' , width printString , ')']].
	^typeString.
]

{ #category : #SQL }
GlorpAbstractStringType >> typeString: aString [
	"If we set the typeString, we are presumably setting it to the non-parameterized name as well"
	typeString := aString.
	super typeString: aString.
]

{ #category : #accessing }
GlorpAbstractStringType >> width [
	^width.
]

{ #category : #accessing }
GlorpAbstractStringType >> width: anInteger [

	width := anInteger = 0 ifTrue: [nil] ifFalse: [anInteger]
]
