"
Data type that is used to store JSON (JavaScript Object Notation) data 
"
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
