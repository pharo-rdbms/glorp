Class {
	#name : #GlorpThingWithLotsOfDifferentCollections,
	#superclass : #Object,
	#instVars : [
		'id',
		'array',
		'orderedCollection',
		'set',
		'bag',
		'sortedCollection',
		'name'
	],
	#category : #'Glorp-Integration-Tests-Models'
}

{ #category : #accessing }
GlorpThingWithLotsOfDifferentCollections >> array [
	^array
]

{ #category : #accessing }
GlorpThingWithLotsOfDifferentCollections >> array: anObject [
	array := anObject
]

{ #category : #accessing }
GlorpThingWithLotsOfDifferentCollections >> bag [
	^bag
]

{ #category : #accessing }
GlorpThingWithLotsOfDifferentCollections >> bag: anObject [
	bag := anObject
]

{ #category : #accessing }
GlorpThingWithLotsOfDifferentCollections >> id [
	^id
]

{ #category : #accessing }
GlorpThingWithLotsOfDifferentCollections >> id: anObject [
	id := anObject
]

{ #category : #'initialize-release' }
GlorpThingWithLotsOfDifferentCollections >> initialize [
	array := #().
	orderedCollection := OrderedCollection new.
	set := Set new.
	bag := Bag new.
	sortedCollection := #() asSortedCollection.
]

{ #category : #accessing }
GlorpThingWithLotsOfDifferentCollections >> name [
	^name
]

{ #category : #accessing }
GlorpThingWithLotsOfDifferentCollections >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GlorpThingWithLotsOfDifferentCollections >> orderedCollection [
	^orderedCollection
]

{ #category : #accessing }
GlorpThingWithLotsOfDifferentCollections >> orderedCollection: anObject [
	orderedCollection := anObject
]

{ #category : #accessing }
GlorpThingWithLotsOfDifferentCollections >> set [
	^set
]

{ #category : #accessing }
GlorpThingWithLotsOfDifferentCollections >> set: anObject [
	set := anObject
]

{ #category : #accessing }
GlorpThingWithLotsOfDifferentCollections >> sortedCollection [
	^sortedCollection
]

{ #category : #accessing }
GlorpThingWithLotsOfDifferentCollections >> sortedCollection: anObject [
	sortedCollection := anObject
]
