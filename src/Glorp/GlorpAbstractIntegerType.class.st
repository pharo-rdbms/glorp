"
Abstract integer type
"
Class {
	#name : #GlorpAbstractIntegerType,
	#superclass : #GlorpAbstractNumericType,
	#category : #'Glorp-Types'
}

{ #category : #converting }
GlorpAbstractIntegerType >> converterForStType: aClass [
	(aClass includesBehavior: Boolean) ifTrue: [^self platform converterNamed: #booleanToInteger].
	^self platform converterNamed: #numberToInteger.
]

{ #category : #converting }
GlorpAbstractIntegerType >> impliedSmalltalkType [
	^Integer.
]

{ #category : #'exdi specific' }
GlorpAbstractIntegerType >> initialize [
	super initialize.
	typeString := 'integer'.
]

{ #category : #testing }
GlorpAbstractIntegerType >> isIntegerType [
	^true
]
