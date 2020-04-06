"
Boolean type
"
Class {
	#name : #GlorpBooleanType,
	#superclass : #GlorpDatabaseType,
	#category : 'Glorp-Types'
}

{ #category : #converting }
GlorpBooleanType >> converterForStType: aClass [
	(aClass includesBehavior: Boolean) ifTrue: [^self platform converterNamed: #booleanToBoolean].
	^self platform nullConverter.
]

{ #category : #converting }
GlorpBooleanType >> impliedSmalltalkType [
	^Boolean.
]

{ #category : #SQL }
GlorpBooleanType >> print: aValue on: aStream [
	aStream nextPutAll: (self platform printBoolean: aValue for: self).
]
