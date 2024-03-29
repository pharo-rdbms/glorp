Class {
	#name : #GlorpTreeNode,
	#superclass : #Object,
	#instVars : [
		'id',
		'children'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

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

{ #category : #initialization }
GlorpTreeNode >> initialize [

	super initialize.
	children := OrderedCollection new
]

{ #category : #printing }
GlorpTreeNode >> printOn: aStream [
	aStream nextPutAll: 'Node('.
	id printOn: aStream.
	aStream nextPut: $).
]
