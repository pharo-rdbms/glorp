"
This class just holds a time, but that time is transformed into a representation in seconds in the database.

Instance Variables:
	id	<Integer>	The primary key
	time	<Time>	The time


"
Class {
	#name : #GlorpTransformedTime,
	#superclass : #Object,
	#instVars : [
		'id',
		'time'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
GlorpTransformedTime >> id [
	^id
]

{ #category : #accessing }
GlorpTransformedTime >> id: anObject [
	id := anObject
]

{ #category : #initialize }
GlorpTransformedTime >> initialize [
	time := Time now.
]

{ #category : #accessing }
GlorpTransformedTime >> time [
	^time
]

{ #category : #accessing }
GlorpTransformedTime >> time: anObject [
	time := anObject
]
