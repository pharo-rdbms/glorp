Class {
	#name : #GlorpJob,
	#superclass : #Object,
	#instVars : [
		'id',
		'description'
	],
	#category : #'Glorp-Unit-Tests-Models - Worker'
}

{ #category : #accessing }
GlorpJob >> description [
	^description
]

{ #category : #accessing }
GlorpJob >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GlorpJob >> id [
	^id
]

{ #category : #accessing }
GlorpJob >> id: anObject [
	id := anObject
]
