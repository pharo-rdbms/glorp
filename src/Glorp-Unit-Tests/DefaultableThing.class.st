Class {
	#name : #DefaultableThing,
	#superclass : #Object,
	#instVars : [
		'id',
		'boolean',
		'integer'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
DefaultableThing >> boolean [
	^boolean
]

{ #category : #accessing }
DefaultableThing >> boolean: anObject [
	boolean := anObject
]

{ #category : #accessing }
DefaultableThing >> id [
	^id
]

{ #category : #accessing }
DefaultableThing >> id: anObject [
	id := anObject
]

{ #category : #accessing }
DefaultableThing >> integer [
	^integer
]

{ #category : #accessing }
DefaultableThing >> integer: anObject [
	integer := anObject
]
