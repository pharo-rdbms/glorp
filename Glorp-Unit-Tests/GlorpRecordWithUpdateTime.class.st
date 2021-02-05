"
This is a model class that has a timestamp which is updated each time it is written.

Instance Variables:
	id	<Integer>	The primary key
	name	<String>	a name
	updateTime	<Timestamp>	When we were last updated.


"
Class {
	#name : #GlorpRecordWithUpdateTime,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'updateTime',
		'updateSomeOtherThing'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
GlorpRecordWithUpdateTime >> id [
	^id.
]

{ #category : #accessing }
GlorpRecordWithUpdateTime >> id: anInteger [
	id := anInteger.
]

{ #category : #accessing }
GlorpRecordWithUpdateTime >> name [
	^name.
]

{ #category : #accessing }
GlorpRecordWithUpdateTime >> name: aString [
	name := aString.
]

{ #category : #accessing }
GlorpRecordWithUpdateTime >> updateSomeOtherThing [
	^updateSomeOtherThing
]

{ #category : #accessing }
GlorpRecordWithUpdateTime >> updateSomeOtherThing: aString [
	updateSomeOtherThing := aString
]

{ #category : #accessing }
GlorpRecordWithUpdateTime >> updateTime [
	^updateTime.
]
