"
BLOB type

Instance Variables
	queryType:		<Object>

queryType
	- xxxxx

"
Class {
	#name : 'GlorpBlobType',
	#superclass : 'GlorpDatabaseType',
	#instVars : [
		'queryType'
	],
	#category : 'Glorp-Types',
	#package : 'Glorp',
	#tag : 'Types'
}

{ #category : 'comparing' }
GlorpBlobType >> = aType [
	super = aType ifFalse: [^false].
	self queryType == self ifTrue: [^true].
	self queryType = aType queryType
		 ifFalse: [^false].
	^true.
]

{ #category : 'converting' }
GlorpBlobType >> converterForStType: aClass [
	self platform isPostgreSQLPlatform ifTrue: [
		(aClass includesBehavior: String) ifTrue: [^self platform converterNamed: #stringToSQLString].
		^self platform converterNamed: #byteArrayToSQLString].
	self platform isOcelotPlatform ifTrue: [^self platform converterNamed: #blobDataToStream].
	(aClass includesBehavior: String) ifTrue: [^self platform converterNamed: #byteArrayToString].
	^self platform nullConverter
]

{ #category : 'comparing' }
GlorpBlobType >> hash [
	^self queryType == self
		ifTrue: [super hash]
		ifFalse: [super hash bitXor: self queryType hash]
]

{ #category : 'types' }
GlorpBlobType >> impliedSmalltalkType [
	^ByteArray.
]

{ #category : 'initialization' }
GlorpBlobType >> initialize [
	super initialize.
	typeString := 'blob'
]

{ #category : 'printing' }
GlorpBlobType >> print: aValue on: aStream [
	self platform printBlob: (aValue isNil ifTrue: [nil] ifFalse: [aValue asByteArray]) on: aStream for: self.
]

{ #category : 'types' }
GlorpBlobType >> queryType [
	"Return the type that we can cast an argument to in order to match against this"
	queryType isNil ifTrue: [^self].
	^queryType.
]

{ #category : 'types' }
GlorpBlobType >> queryType: aType [
	"Set the type that we can cast an argument to in order to match against this"
	queryType := aType.
]

{ #category : 'testing' }
GlorpBlobType >> requiresConvertToVarbinary [
	"This is a hack for testing against SQL Server"
	^true.
]
