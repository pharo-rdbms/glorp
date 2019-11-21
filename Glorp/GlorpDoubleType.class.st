"
Double type
"
Class {
	#name : #GlorpDoubleType,
	#superclass : #GlorpAbstractNumericType,
	#category : 'Glorp-Types'
}

{ #category : #converting }
GlorpDoubleType >> converterForStType: aClass [

	^self platform converterNamed: #numberToDouble.
]

{ #category : #converting }
GlorpDoubleType >> impliedSmalltalkType [
	^Dialect doublePrecisionFloatClass.
]

{ #category : #initialize }
GlorpDoubleType >> initialize [
	super initialize.
	typeString := 'double precision'.
]
