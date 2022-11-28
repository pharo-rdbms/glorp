Class {
	#name : #GlorpRowMapForMementosCollectionTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'transaction',
		'rowMap',
		'collection',
		'newCollection',
		'copy'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #tests }
GlorpRowMapForMementosCollectionTest >> createRowMap [
	rowMap := RowMapForMementos withCorrespondenceMap: transaction undoMap.
	rowMap collectionMementos: transaction collectionMementos.
	newCollection := rowMap collectionMementoFor: collection.
]

{ #category : #support }
GlorpRowMapForMementosCollectionTest >> setUp [
	transaction := ObjectTransaction new.
	rowMap := nil.
]

{ #category : #tests }
GlorpRowMapForMementosCollectionTest >> testArray [
	collection := Array with: 1 with: 2 with: 3 with: 4.
	copy := collection copy.
	transaction register: collection.
	collection at: 3 put: 'hello'.
	self createRowMap.
	self assert: newCollection = copy.
	self deny: newCollection = collection
		description: 'Copying is too shallow both here and in registerTransientInternalsOfCollection:'.
]

{ #category : #tests }
GlorpRowMapForMementosCollectionTest >> testDictionary [
	collection := Dictionary new.
	1 to: 50 do: [:i | collection at: i put: i printString].
	copy := collection copy.
	transaction register: collection.
	#( 1 2 7 43 15 9 10 17 18 19 33 23) do: [:i | collection removeKey: i].
	collection at: 3 put: 'hello'.
	self createRowMap.
	self assert: newCollection size = copy size.
	self assert: newCollection keys asSortedCollection = copy keys asSortedCollection.
	self assert: newCollection values asSortedCollection = copy values asSortedCollection.
	self deny: newCollection values asSortedCollection = collection values asSortedCollection
		description: 'Copying is too shallow both here and in registerTransientInternalsOfCollection:'.
]

{ #category : #tests }
GlorpRowMapForMementosCollectionTest >> testIdentityDictionary [
	collection := IdentityDictionary new.
	1 to: 50 do: [:i | collection at: i put: i printString].
	copy := collection copy.
	transaction register: collection.
	#( 1 2 7 43 15 9 10 17 18 19 33 23) do: [:i | collection removeKey: i].
	collection at: 3 put: 'hello'.
	self createRowMap.
	self assert: newCollection size = copy size.
	self assert: newCollection keys asSortedCollection = copy keys asSortedCollection.
	self assert: newCollection values asSortedCollection = copy values asSortedCollection.
	self deny: newCollection values asSortedCollection = collection values asSortedCollection
		description: 'Copying is too shallow both here and in registerTransientInternalsOfCollection:'.
]

{ #category : #tests }
GlorpRowMapForMementosCollectionTest >> testOrderedCollection [
	collection := (1 to: 50) asOrderedCollection.
	copy := collection copy.
	transaction register: collection.
	12 timesRepeat: [collection removeLast].
	collection at: 3 put: 'hello'.
	self createRowMap.
	self assert: newCollection = copy.
	self deny: newCollection = collection
		description: 'Copying is too shallow both here and in registerTransientInternalsOfCollection:'.
]

{ #category : #tests }
GlorpRowMapForMementosCollectionTest >> testOrderedSet [
	collection := (Dialect smalltalkAt: #OrderedSet ifAbsent: [^self]) new.
	1 to: 50 do: [:i | collection add: i].
	copy := collection copy.
	transaction register: collection.
	#( 1 2 7 43 15 9 10 17 18 19 33 23) do: [:i | collection remove: i].
	collection add: 999.
	self createRowMap.
	self assert: newCollection asSortedCollection = copy asSortedCollection.
	self deny: newCollection asSortedCollection = collection asSortedCollection
		description: 'Copying is too shallow both here and in registerTransientInternalsOfCollection:'.
]

{ #category : #tests }
GlorpRowMapForMementosCollectionTest >> testRBSmallDictionary [
	collection := (Dialect smalltalkAt: #RBSmallDictionary ifAbsent: [^self]) new.
	1 to: 50 do: [:i | collection at: i put: i printString].
	copy := collection copy.
	transaction register: collection.
	#( 1 2 7 43 15 9 10 17 18 19 33 23) do: [:i | collection removeKey: i].
	collection at: 3 put: 'hello'.
	self createRowMap.
	self assert: newCollection size = copy size.
	self assert: newCollection keys asSortedCollection = copy keys asSortedCollection.
	self assert: newCollection values asSortedCollection = copy values asSortedCollection.
	self deny: newCollection values asSortedCollection = collection values asSortedCollection
		description: 'Copying is too shallow both here and in registerTransientInternalsOfCollection:'.
]

{ #category : #tests }
GlorpRowMapForMementosCollectionTest >> testSet [
	collection := (1 to: 50) asSet.
	copy := collection copy.
	transaction register: collection.
	1 to: 12 do: [:i | collection remove: i].
	collection add: 'hello'.
	self createRowMap.
	self assert: newCollection asSortedCollection = copy asSortedCollection.
	self deny: newCollection size = collection size
		description: 'Copying is too shallow both here and in registerTransientInternalsOfCollection:'.
]
