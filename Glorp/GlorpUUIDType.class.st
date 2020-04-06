Class {
	#name : #GlorpUUIDType,
	#superclass : #GlorpDatabaseType,
	#category : #'Glorp-Types'
}

{ #category : #converting }
GlorpUUIDType >> impliedSmalltalkType [
	^UUID.
]

{ #category : #initialize }
GlorpUUIDType >> initialize [ 
	super initialize.
	typeString := #uuid
]
