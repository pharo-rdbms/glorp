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

{ #category : #examples }
GlorpThingWithLotsOfDifferentCollections class >> example1 [
	| example array |
	example := self new.
	example name: 'fred'.
	array := Array with: (GlorpThingOne named: 'array1') with: (GlorpThingOne named: 'array2') with: (GlorpThingOne named: 'array3').
	example array: array.
	example set add: (GlorpThingOne named: 'set1').
	example set add: (GlorpThingOne named: 'set2').	
	example orderedCollection add: (GlorpThingOne named: 'orderedCollection1').
	example orderedCollection add: (GlorpThingOne named: 'orderedCollection2').
	example bag add: (GlorpThingOne named: 'bag1').
	example bag add: (GlorpThingOne named: 'bag2').
	example sortedCollection add: (GlorpThingOne named: 'sorted1').
	example sortedCollection add: (GlorpThingOne named: 'sorted2').
	example sortedCollection add: (GlorpThingOne named: 'sorted3').
	example sortedCollection add: (GlorpThingOne named: 'sorted4').
	^example.
]

{ #category : #examples }
GlorpThingWithLotsOfDifferentCollections class >> exampleForOrdering [
	| example |
	example := self new.
	example name: 'order'.
	example orderedCollection add: (GlorpThingOne named: 'oc6').
	example orderedCollection add: (GlorpThingOne named: 'oc5').
	example orderedCollection add: (GlorpThingOne named: 'oc4').
	example orderedCollection add: (GlorpThingOne named: 'oc3').
	example orderedCollection add: (GlorpThingOne named: 'oc7').
	example orderedCollection add: (GlorpThingOne named: 'oc8').
	example array: (#('a1' 'a2' 'a3' 'a9' 'a8' 'a7') collect: [:each | GlorpThingOne named: each]).
	^example
]

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
