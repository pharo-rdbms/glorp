Class {
	#name : #GlorpPartialWritesTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'session'
	],
	#category : 'Glorp-Tests-Database'
}

{ #category : #support }
GlorpPartialWritesTest >> setUp [
	super setUp.
	session := GlorpSessionResource current newSession.
]

{ #category : #tests }
GlorpPartialWritesTest >> testNoDifferenceNoWrite [
self todo
]

{ #category : #tests }
GlorpPartialWritesTest >> testWritingNewObject [
self todo
]

{ #category : #tests }
GlorpPartialWritesTest >> testWritingObjectWithAddedComponent [
self todo
]

{ #category : #tests }
GlorpPartialWritesTest >> testWritingObjectWithChangedAttribute [
self todo
]

{ #category : #tests }
GlorpPartialWritesTest >> testWritingObjectWithChangedComponent [
self todo
]

{ #category : #tests }
GlorpPartialWritesTest >> testWritingObjectWithChangedComponentAttribute [
self todo
]

{ #category : #tests }
GlorpPartialWritesTest >> testWritingObjectWithDeletedComponent [
self todo
]

{ #category : #tests }
GlorpPartialWritesTest >> testWritingObjectWithDeletedRelationship [
self todo
]
