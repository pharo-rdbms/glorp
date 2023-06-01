"
Date and time type
"
Class {
	#name : #GlorpDateAndTimeType,
	#superclass : #GlorpDatabaseType,
	#category : #'Glorp-Types'
}

{ #category : #converting }
GlorpDateAndTimeType >> converterForStType: aClass [

	^self platform converterNamed: #dateAndTime.
]

{ #category : #accessing }
GlorpDateAndTimeType >> impliedSmalltalkType [
	^Dialect dateAndTimeClass
]

{ #category : #printing }
GlorpDateAndTimeType >> print: aValue on: aStream [

	aValue isNil
		ifTrue: [ aStream nextPutAll: 'NULL' ]
		ifFalse:[
			aValue printOn: aStream ].

]
