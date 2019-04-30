Class {
	#name : #GlorpTreeNode,
	#superclass : #Object,
	#instVars : [
		'id',
		'children'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpTreeNode class >> new [
	^super new initialize.
]

{ #category : #'As yet unclassified' }
GlorpTreeNode >> children [
	^children.
]

{ #category : #'As yet unclassified' }
GlorpTreeNode >> children: aCollection [
	children := aCollection.
]

{ #category : #'As yet unclassified' }
GlorpTreeNode >> id [
	^id.
]

{ #category : #'As yet unclassified' }
GlorpTreeNode >> id: anInteger [
	id := anInteger.
]

{ #category : #'As yet unclassified' }
GlorpTreeNode >> initialize [
	children := OrderedCollection new.
]

{ #category : #printing }
GlorpTreeNode >> printOn: aStream [
	aStream nextPutAll: 'Node('.
	id printOn: aStream.
	aStream nextPut: $).
]
