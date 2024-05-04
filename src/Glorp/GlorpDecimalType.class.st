"
Data type used to store precise decimal numbers
"
Class {
	#name : 'GlorpDecimalType',
	#superclass : 'GlorpNumericType',
	#category : 'Glorp-Types',
	#package : 'Glorp',
	#tag : 'Types'
}

{ #category : 'converting' }
GlorpDecimalType >> converterForStType: aClass [

	^self platform converterNamed: #numberToDecimal.
]

{ #category : 'initialization' }
GlorpDecimalType >> initialize [

	super initialize.
	typeString := 'decimal'.
]
