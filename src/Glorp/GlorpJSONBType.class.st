Class {
	#name : #GlorpJSONBType,
	#superclass : #GlorpJSONType,
	#category : #'Glorp-Types'
}

{ #category : #initialization }
GlorpJSONBType >> initialize [
	super initialize.
	typeString := 'jsonb'.
]
