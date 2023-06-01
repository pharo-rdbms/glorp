Class {
	#name : #GlorpDecimalType,
	#superclass : #GlorpNumericType,
	#category : #'Glorp-Types'
}

{ #category : #converting }
GlorpDecimalType >> converterForStType: aClass [

	^self platform converterNamed: #numberToDecimal.
]

{ #category : #initialization }
GlorpDecimalType >> initialize [

	super initialize.
	typeString := 'decimal'.
]
