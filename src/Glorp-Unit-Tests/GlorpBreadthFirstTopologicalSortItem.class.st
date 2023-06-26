Class {
	#name : #GlorpBreadthFirstTopologicalSortItem,
	#superclass : #Object,
	#instVars : [
		'parent',
		'id',
		'relatedItems',
		'status'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
GlorpBreadthFirstTopologicalSortItem >> id [
	^id
]

{ #category : #accessing }
GlorpBreadthFirstTopologicalSortItem >> id: anObject [
	id := anObject
]

{ #category : #'initialize-release' }
GlorpBreadthFirstTopologicalSortItem >> initialize [
	relatedItems := OrderedCollection new.
]

{ #category : #accessing }
GlorpBreadthFirstTopologicalSortItem >> parent [
	^parent
]

{ #category : #accessing }
GlorpBreadthFirstTopologicalSortItem >> parent: anObject [
	parent := anObject
]

{ #category : #printing }
GlorpBreadthFirstTopologicalSortItem >> printOn: aStream [
	aStream nextPut: $(.
	id printOn: aStream.
	aStream nextPut: $).
]

{ #category : #relationships }
GlorpBreadthFirstTopologicalSortItem >> relateTo: anItem [
	relatedItems add: anItem.
]

{ #category : #accessing }
GlorpBreadthFirstTopologicalSortItem >> relatedItems [
	^relatedItems
]

{ #category : #accessing }
GlorpBreadthFirstTopologicalSortItem >> relatedItems: aCollection [
	relatedItems := aCollection
]

{ #category : #accessing }
GlorpBreadthFirstTopologicalSortItem >> status [
	^status
]

{ #category : #accessing }
GlorpBreadthFirstTopologicalSortItem >> status: aSymbol [
	status := aSymbol
]
