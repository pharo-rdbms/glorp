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
