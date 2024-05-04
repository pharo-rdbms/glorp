"
Float type
"
Class {
	#name : 'GlorpFloatType',
	#superclass : 'GlorpAbstractNumericType',
	#category : 'Glorp-Types',
	#package : 'Glorp',
	#tag : 'Types'
}

{ #category : 'converting' }
GlorpFloatType >> converterForStType: aClass [

	^self platform converterNamed: #numberToFloat.
]

{ #category : 'converting' }
GlorpFloatType >> impliedSmalltalkType [
	^Float.
]

{ #category : 'initialization' }
GlorpFloatType >> initialize [
	super initialize.
	typeString := 'float4'.
]
