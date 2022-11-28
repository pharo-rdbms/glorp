Class {
	#name : #GlorpDecimalType,
	#superclass : #GlorpNumericType,
	#category : 'Glorp-Types'
}

{ #category : #converting }
GlorpDecimalType >> converterForStType: aClass [

	^self platform converterNamed: #numberToDecimal.
]

{ #category : #initialize }
GlorpDecimalType >> initialize [

	super initialize.
	typeString := 'decimal'.
]
