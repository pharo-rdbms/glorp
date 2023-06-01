"
PGArray refers to the array data type in PostgreSQL. It allows to store and manipulate arrays of various data types within a single column of a table.
"
Class {
	#name : #GlorpPGArrayType,
	#superclass : #GlorpAbstractStringType,
	#category : #'Glorp-Types'
}

{ #category : #initialization }
GlorpPGArrayType >> initialize [
	super initialize.
	typeString := 'ARRAY'.
]

{ #category : #testing }
GlorpPGArrayType >> isVariableWidth [
	^true
]
