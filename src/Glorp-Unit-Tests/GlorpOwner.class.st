Class {
	#name : #GlorpOwner,
	#superclass : #Object,
	#instVars : [
		'id',
		'slave',
		'slaves'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
GlorpOwner >> id [
	^id.
]

{ #category : #accessing }
GlorpOwner >> id: anObject [
	id := anObject.
]

{ #category : #accessing }
GlorpOwner >> slave [
	^slave.
]

{ #category : #accessing }
GlorpOwner >> slave: anObject [
	slave := anObject.
]

{ #category : #accessing }
GlorpOwner >> slaves [
	^slaves.
]

{ #category : #accessing }
GlorpOwner >> slaves: anObject [
	slaves := anObject.
]
