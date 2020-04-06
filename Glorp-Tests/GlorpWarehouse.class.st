Class {
	#name : #GlorpWarehouse,
	#superclass : #Object,
	#instVars : [
		'id',
		'address',
		'currentItem',
		'items'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #accessing }
GlorpWarehouse >> address [
	^address
]

{ #category : #accessing }
GlorpWarehouse >> address: anObject [
	address := anObject
]

{ #category : #accessing }
GlorpWarehouse >> currentItem [
	^currentItem
]

{ #category : #accessing }
GlorpWarehouse >> currentItem: anInventoryItem [
	currentItem := anInventoryItem
]

{ #category : #accessing }
GlorpWarehouse >> id [
	^id
]

{ #category : #accessing }
GlorpWarehouse >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GlorpWarehouse >> items [
	^items
]

{ #category : #accessing }
GlorpWarehouse >> items: aCollection [
	items := aCollection
]
