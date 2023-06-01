"
JSONB is a data type in relational databases, particularly in PostgreSQL, that is used to store JSON (JavaScript Object Notation) data in a binary format. 
"
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
