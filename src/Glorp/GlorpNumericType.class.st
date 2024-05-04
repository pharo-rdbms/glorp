"
Instance Variables
	precision:		<Object>
	scale:		<Object>

precision
	- xxxxx

scale
	- xxxxx

"
Class {
	#name : 'GlorpNumericType',
	#superclass : 'GlorpAbstractNumericType',
	#instVars : [
		'precision',
		'scale'
	],
	#category : 'Glorp-Types',
	#package : 'Glorp',
	#tag : 'Types'
}

{ #category : 'comparing' }
GlorpNumericType >> = aType [

	"We do a special case check here that something that reads back as numeric with no scale/precision counts as being the same as an integer type"
	((aType class == self platform integer class) and: [self isIntegerType]) ifTrue: [^true].
	super = aType ifFalse: [^false].
	self precision = aType precision ifFalse: [^false].
	self scale = aType scale ifFalse: [^false].
	^true.
]

{ #category : 'converting' }
GlorpNumericType >> converterForStType: aClass [
	(aClass includesBehavior: Boolean) ifTrue: [^self platform converterNamed: #booleanToInteger].
	^self platform converterNamed: #numberToNumber.
]

{ #category : 'testing' }
GlorpNumericType >> hasParameters [
	"Return true if this has modifiable parameters. That is, when we return one of these, should we return a copy rather than trying to save space be re-using instances"
	^true.
]

{ #category : 'comparing' }
GlorpNumericType >> hash [
	"A very special case here, if we're effectively an Integer, then we need to hash in a way compatible with GlorpIntegerType"
	self isIntegerType ifTrue: [^self platform hash bitXor: self impliedSmalltalkType hash].
	^(super hash bitXor: self precision hash) bitXor: self scale hash
]

{ #category : 'converting' }
GlorpNumericType >> impliedSmalltalkType [
	self isIntegerType ifTrue: [^Integer].
	^super impliedSmalltalkType
]

{ #category : 'initialization' }
GlorpNumericType >> initialize [
	super initialize.
	typeString := 'numeric'.
]

{ #category : 'testing' }
GlorpNumericType >> isIntegerType [
	"If we have no precision and no scale, we're effectively an Integer"
	^self precision isNil and: [self scale isNil]
]

{ #category : 'accessing' }
GlorpNumericType >> precision [
	^precision.
]

{ #category : 'accessing' }
GlorpNumericType >> precision: anInteger [

	precision := anInteger.
]

{ #category : 'accessing' }
GlorpNumericType >> scale [
	^scale.
]

{ #category : 'accessing' }
GlorpNumericType >> scale: anInteger [

	scale := anInteger.
]

{ #category : 'SQL' }
GlorpNumericType >> typeString [
	| w |
	platform supportsVariableSizedNumerics ifFalse: [^typeString].
	w := WriteStream on: String new.
	w nextPutAll: typeString.
	precision isNil 
		ifFalse: 
			[w nextPutAll: '(' , precision printString.
			scale isNil ifFalse: [w nextPutAll: ',' , scale printString].
			w nextPutAll: ')'].
	^w contents
]
