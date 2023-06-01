"
The bytea data type allows storage of binary strings. It is a binary data type in the PostgreSQL
"
Class {
	#name : #GlorpBinaryType,
	#superclass : #GlorpDatabaseType,
	#category : #'Glorp-Types'
}

{ #category : #converting }
GlorpBinaryType >> converterForStType: aClass [
	^self platform byteaConverter 
]

{ #category : #initialization }
GlorpBinaryType >> initialize [ 
	super initialize.
	typeString := #bytea
]
