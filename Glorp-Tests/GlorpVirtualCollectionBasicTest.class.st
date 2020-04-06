Class {
	#name : #GlorpVirtualCollectionBasicTest,
	#superclass : #GlorpSessionBasedTest,
	#instVars : [
		'vc'
	],
	#category : 'Glorp-Tests-Database'
}

{ #category : #support }
GlorpVirtualCollectionBasicTest >> realObjects [
	"Get the real objects from a virtual collection without resorting to any of its mechanisms except do:, so we can validate against more complex things."
	^self realObjectsFrom: vc.
]

{ #category : #support }
GlorpVirtualCollectionBasicTest >> realObjectsFrom: aVirtualCollection [
	"Get the real objects from a virtual collection without resorting to any of its mechanisms except do:, so we can validate against more complex things."
	| all |
	all := OrderedCollection new.
	aVirtualCollection do: [:each | all add: each].
	^all.
]

{ #category : #support }
GlorpVirtualCollectionBasicTest >> setUp [
	super setUp.
	session beginTransaction.
	self writePersonRows.
	vc := session virtualCollectionOf: GlorpPerson.
]

{ #category : #support }
GlorpVirtualCollectionBasicTest >> tearDown [
	session rollbackTransaction.
	super tearDown.
]

{ #category : #tests }
GlorpVirtualCollectionBasicTest >> testCollect [
	| ids |
	ids := vc collect: [:each | each id].
	
	self assert: ids size = 3.
	ids do: [:each | self assert: each isInteger].
]

{ #category : #tests }
GlorpVirtualCollectionBasicTest >> testCreation [
	
	self assert: vc notNil.
	self should: [vc isKindOf: GlorpVirtualCollection].
]

{ #category : #tests }
GlorpVirtualCollectionBasicTest >> testDo [

	| all |
	all := OrderedCollection new.
	vc do: [:each |
		self assert: (each isKindOf: GlorpPerson).
		all add: each.
		].
	self assert: all size = 3.
	self assert: all asSet size = 3.
	self assert: (all collect: [:each | each id]) asSortedCollection asArray = #(86 87 88).
]

{ #category : #tests }
GlorpVirtualCollectionBasicTest >> testInject [
	| sumofIds |
	sumofIds := vc inject: 0 into: [:sum :each | sum + each id].
	self assert: sumofIds = (86 + 87 + 88).
]

{ #category : #tests }
GlorpVirtualCollectionBasicTest >> testIsEmpty [
	| vc2 |
	self deny: vc isEmpty.
	vc2 := vc select: [:each | each id = 98].
	self assert: vc2 isEmpty.
]

{ #category : #tests }
GlorpVirtualCollectionBasicTest >> testReject [
	| vc2 |
	vc2 := vc reject: [:each | each id > 87 ].
	self deny: vc isInstantiated.
	self deny: vc2 isInstantiated.
	self assert: vc2 size = 2.
	self deny: vc isInstantiated.
	self assert: vc size = 3.
	self assert: (self realObjectsFrom: vc2) size = 2.
]

{ #category : #tests }
GlorpVirtualCollectionBasicTest >> testSelect [
	| vc2 |
	vc2 := vc select: [:each | each id <= 87 ].
	self deny: vc isInstantiated.
	self deny: vc2 isInstantiated.
	self assert: vc2 size = 2.
	self deny: vc isInstantiated.
	self assert: vc size = 3.
	self assert: (self realObjectsFrom: vc2) size = 2.
]

{ #category : #support }
GlorpVirtualCollectionBasicTest >> writePersonRows [
	session writeRow: session system exampleAddressRowForOrdering1.
	session writeRow: session system exampleAddressRowForOrdering2.
	session writeRow: session system exampleAddressRowForOrdering3.
	session writeRow: session system examplePersonRowForOrdering1.
	session writeRow: session system examplePersonRowForOrdering2.
	session writeRow: session system examplePersonRowForOrdering3.
]
