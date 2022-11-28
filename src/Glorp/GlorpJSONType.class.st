Class {
	#name : #GlorpJSONType,
	#superclass : #GlorpAbstractStringType,
	#category : #'Glorp-Types'
}

{ #category : #converting }
GlorpJSONType >> converterForStType: aClass [
	 ^self platform converterNamed: #jsonToString.
]

{ #category : #initialize }
GlorpJSONType >> initialize [
	super initialize.
	typeString := 'json'.
]
