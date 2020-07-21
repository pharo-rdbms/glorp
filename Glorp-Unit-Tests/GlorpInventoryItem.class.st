Class {
	#name : #GlorpInventoryItem,
	#superclass : #Object,
	#instVars : [
		'id',
		'name'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
GlorpInventoryItem >> id [
	^id
]

{ #category : #accessing }
GlorpInventoryItem >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GlorpInventoryItem >> name [
	^name
]

{ #category : #accessing }
GlorpInventoryItem >> name: anObject [
	name := anObject
]

{ #category : #printing }
GlorpInventoryItem >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: id printString.
	aStream nextPut: $,.
	aStream nextPutAll: name printString.
	aStream nextPut: $).
]
