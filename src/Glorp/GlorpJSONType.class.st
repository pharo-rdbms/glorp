Class {
	#name : #GlorpJSONType,
	#superclass : #GlorpAbstractStringType,
	#category : #'Glorp-Types'
}

{ #category : #converting }
GlorpJSONType >> converterForStType: aClass [
	 ^self platform converterNamed: #jsonToString.
]

{ #category : #initialization }
GlorpJSONType >> initialize [
	super initialize.
	typeString := 'json'.
]
