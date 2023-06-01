"
Time type
"
Class {
	#name : #GlorpTimeType,
	#superclass : #GlorpDatabaseType,
	#category : #'Glorp-Types'
}

{ #category : #converting }
GlorpTimeType >> converterForStType: aClass [

	^self platform converterNamed: #time.
]

{ #category : #converting }
GlorpTimeType >> impliedSmalltalkType [
	^Time.
]

{ #category : #SQL }
GlorpTimeType >> print: aValue on: aStream [
	aStream nextPutAll: (self platform printTime: aValue for: self).
]
