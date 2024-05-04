"
The UUID (Universally Unique Identifier) type is a data type used to store unique identifiers 
"
Class {
	#name : 'GlorpUUIDType',
	#superclass : 'GlorpDatabaseType',
	#category : 'Glorp-Types',
	#package : 'Glorp',
	#tag : 'Types'
}

{ #category : 'converting' }
GlorpUUIDType >> impliedSmalltalkType [
	^UUID.
]

{ #category : 'initialize' }
GlorpUUIDType >> initialize [ 
	super initialize.
	typeString := #uuid
]
