Class {
	#name : #GlorpReadingDifferentCollectionsTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'system',
		'session',
		'singleQuery',
		'allQuery',
		'singleResult',
		'allResult'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #tests }
GlorpReadingDifferentCollectionsTest >> check: aClass [
	| collectionClass |
	collectionClass := aClass isBehavior ifTrue: [aClass] ifFalse: [aClass class].
	singleQuery collectionType: aClass.
	allQuery collectionType: aClass.
	singleResult := session execute: singleQuery.
	allResult := session execute: allQuery.
	self assert: singleResult class == collectionClass.
	self assert: allResult class == collectionClass.
	self assert: singleResult size = 1.
	self assert: allResult size = 2.
]

{ #category : #running }
GlorpReadingDifferentCollectionsTest >> setUp [

	super setUp.
	session := GlorpSessionResource current newSession.
	system := session system.
	session beginTransaction.
	self writeAccountRows.
	singleQuery := Query read: GlorpBankAccount
				where: [:passenger | passenger id = 6].
	allQuery := Query read: GlorpBankAccount
]

{ #category : #running }
GlorpReadingDifferentCollectionsTest >> tearDown [

	session rollbackTransaction.
	super tearDown
]

{ #category : #tests }
GlorpReadingDifferentCollectionsTest >> testArray [
	self check: Array.
]

{ #category : #tests }
GlorpReadingDifferentCollectionsTest >> testBlank [
	singleResult := session execute: singleQuery.
	allResult := session execute: allQuery.
	self assert: singleResult class == Array.
	self assert: allResult class == Array.
	self assert: singleResult size = 1.
	self assert: allResult size = 2.
]

{ #category : #tests }
GlorpReadingDifferentCollectionsTest >> testOrderedCollection [
	self check: OrderedCollection.
]

{ #category : #tests }
GlorpReadingDifferentCollectionsTest >> testSet [
	self check: Set.
]

{ #category : #tests }
GlorpReadingDifferentCollectionsTest >> testSortedCollection [
	self check: SortedCollection.
	self assert: allResult first <= allResult last.
]

{ #category : #tests }
GlorpReadingDifferentCollectionsTest >> testSortedCollectionReversed [
	self check: (SortedCollection sortBlock: [:a :b | b <= a]).
	self deny: allResult last <= allResult first.
]

{ #category : #setup }
GlorpReadingDifferentCollectionsTest >> writeAccountRows [
	| accountRow1 accountRow2 |

	accountRow1 := session system exampleAccountRow1. 
	accountRow2 := session system exampleAccountRow2.
	session writeRow: accountRow1.
	session writeRow: accountRow2.
]
