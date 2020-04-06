"
Date and time type
"
Class {
	#name : #GlorpDateAndTimeType,
	#superclass : #GlorpDatabaseType,
	#category : 'Glorp-Types'
}

{ #category : #'as yet unclassified' }
GlorpDateAndTimeType >> converterForStType: aClass [

	^self platform converterNamed: #dateAndTime.
]

{ #category : #'as yet unclassified' }
GlorpDateAndTimeType >> impliedSmalltalkType [
	^Dialect dateAndTimeClass
]

{ #category : #'as yet unclassified' }
GlorpDateAndTimeType >> print: aValue on: aStream [

	aValue isNil
		ifTrue: [ aStream nextPutAll: 'NULL' ]
		ifFalse:[
			aValue printOn: aStream ].

]
