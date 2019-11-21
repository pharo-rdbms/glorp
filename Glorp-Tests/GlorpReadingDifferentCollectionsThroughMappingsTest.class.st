Class {
	#name : #GlorpReadingDifferentCollectionsThroughMappingsTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'system',
		'session'
	],
	#category : 'Glorp-Tests-Database'
}

{ #category : #resources }
GlorpReadingDifferentCollectionsThroughMappingsTest class >> resources [
	^Array with: GlorpDatabaseLoginResource with: GlorpDemoTablePopulatorResource with: GlorpSessionResource.
]

{ #category : #setup }
GlorpReadingDifferentCollectionsThroughMappingsTest >> descriptorClass [
	^GlorpCollectionTypesDescriptorSystem.
]

{ #category : #setup }
GlorpReadingDifferentCollectionsThroughMappingsTest >> setUp [
	super setUp.
	session := GlorpSessionResource current newSession.
	system := self descriptorClass forPlatform: session platform.
	session system: system.
	session beginTransaction.
]

{ #category : #setup }
GlorpReadingDifferentCollectionsThroughMappingsTest >> tearDown [
	super tearDown.
	session rollbackTransaction.
]

{ #category : #tests }
GlorpReadingDifferentCollectionsThroughMappingsTest >> testReadBack [
	"Some dialects (e.g. VA) inline yourself so we must send yourSelf."

	| thing list |
	self writeRows.
	session reset.
	list := session read: GlorpThingWithLotsOfDifferentCollections.
	self assert: list size = 1.
	thing := list first.
	self assert: thing array size = 3.
	self
		assert:
			(self validateFor: thing array against: #('array1' 'array2' 'array3')).
	self assert: thing array yourSelf class = Array.
	self assert: thing set size = 2.
	self assert: thing set yourSelf class = Set.
	self assert: (self validateFor: thing set against: #('set1' 'set2')).
	self assert: thing orderedCollection size = 2.
	self assert: thing orderedCollection yourSelf class = OrderedCollection.
	self
		assert:
			(self
				validateFor: thing orderedCollection
				against: #('orderedCollection1' 'orderedCollection2')).
	self assert: thing orderedCollection first name = 'orderedCollection1'.
	self assert: thing bag size = 2.
	self assert: thing bag yourSelf class = Bag.
	self assert: (self validateFor: thing bag against: #('bag1' 'bag2')).
	self assert: thing sortedCollection size = 4.
	self assert: thing sortedCollection yourSelf class = SortedCollection.
	self assert:
			(thing sortedCollection collect: [:each | each name]) asArray
				= #('sorted1' 'sorted2' 'sorted3' 'sorted4').
]

{ #category : #tests }
GlorpReadingDifferentCollectionsThroughMappingsTest >> testReadBackOneOfSeveral [
	"Some dialects (e.g. VA) inline yourself so we must send yourSelf."

	| thing list |
	self writeMore.
	session reset.
	list := session read: GlorpThingWithLotsOfDifferentCollections where: [:each | each name = 'fred'].
	self assert: list size = 1.
	thing := list first.
	self assert: thing array size = 3.
	self
		assert:
			(self validateFor: thing array against: #('array1' 'array2' 'array3')).
	self assert: thing array yourSelf class = Array.
	self assert: thing set size = 2.
	self assert: thing set yourSelf class = Set.
	self assert: (self validateFor: thing set against: #('set1' 'set2')).
	self assert: thing orderedCollection size = 2.
	self assert: thing orderedCollection yourSelf class = OrderedCollection.
	self
		assert:
			(self
				validateFor: thing orderedCollection
				against: #('orderedCollection1' 'orderedCollection2')).
	self assert: thing bag size = 2.
	self assert: thing bag yourSelf class = Bag.
	self assert: (self validateFor: thing bag against: #('bag1' 'bag2')).
	self assert: thing sortedCollection size = 4.
	self assert: thing sortedCollection yourSelf class = SortedCollection.
	self assert:
			(thing sortedCollection collect: [:each | each name]) asArray
				= #('sorted1' 'sorted2' 'sorted3' 'sorted4').
]

{ #category : #tests }
GlorpReadingDifferentCollectionsThroughMappingsTest >> testReadCollectionWithOrder [
	| thing list |
	session transact: [session register: GlorpThingWithLotsOfDifferentCollections exampleForOrdering].
	session reset.
	list := session read: GlorpThingWithLotsOfDifferentCollections.
	self assert: list size = 1.
	thing := list first.
	self assert: thing orderedCollection size = 6.
	self
		assert:
			(thing orderedCollection collect: [:each | each name]) asArray = #('oc6' 'oc5' 'oc4' 'oc3' 'oc7' 'oc8')
]

{ #category : #tests }
GlorpReadingDifferentCollectionsThroughMappingsTest >> testReadManyToManyWithOrder [
	| thing list |
	session transact: [session register: GlorpThingWithLotsOfDifferentCollections exampleForOrdering].
	session reset.
	list := session read: GlorpThingWithLotsOfDifferentCollections.
	self assert: list size = 1.
	thing := list first.
	self assert: thing orderedCollection size = 6.
	self
		assert:
			(thing orderedCollection collect: [:each | each name]) asArray = #('oc6' 'oc5' 'oc4' 'oc3' 'oc7' 'oc8')
]

{ #category : #tests }
GlorpReadingDifferentCollectionsThroughMappingsTest >> testReadOneToManyWithOrder [
	| thing list |
	session transact: [session register: GlorpThingWithLotsOfDifferentCollections exampleForOrdering].
	session reset.
	list := session read: GlorpThingWithLotsOfDifferentCollections.
	self assert: list size = 1.
	thing := list first.
	self assert: thing array size = 6.
	self
		assert:
			(thing array collect: [:each | each name]) asArray = #('a1' 'a2' 'a3' 'a9' 'a8' 'a7')
]

{ #category : #tests }
GlorpReadingDifferentCollectionsThroughMappingsTest >> validateFor: aCollection against: expectedArrayContents [
	^(aCollection collect: [:each | each name]) asSortedCollection asArray
		= expectedArrayContents.
]

{ #category : #setup }
GlorpReadingDifferentCollectionsThroughMappingsTest >> writeMore [

	| other |
	session transact: [
		session register: GlorpThingWithLotsOfDifferentCollections example1.
		other := GlorpThingWithLotsOfDifferentCollections example1.
		other name: 'barney'.
		session register: other].
]

{ #category : #setup }
GlorpReadingDifferentCollectionsThroughMappingsTest >> writeRows [

	session transact: [
		session register: GlorpThingWithLotsOfDifferentCollections example1].
]
