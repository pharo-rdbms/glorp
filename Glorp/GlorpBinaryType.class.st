Class {
	#name : #GlorpBinaryType,
	#superclass : #GlorpDatabaseType,
	#category : #'Glorp-Types'
}

{ #category : #converting }
GlorpBinaryType >> converterForStType: aClass [
	^self platform byteaConverter 
]

{ #category : #initialize }
GlorpBinaryType >> initialize [ 
	super initialize.
	typeString := #bytea
]
