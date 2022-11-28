Class {
	#name : #GlorpJSONBType,
	#superclass : #GlorpJSONType,
	#category : #'Glorp-Types'
}

{ #category : #initialize }
GlorpJSONBType >> initialize [
	super initialize.
	typeString := 'jsonb'.
]
