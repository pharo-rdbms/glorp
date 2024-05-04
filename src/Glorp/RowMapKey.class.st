"
This class serves as a key for a dictionary containing two sub-keys, where we want to be able to look up based on the identity of both sub-keys paired together. This is used primarily for many-to-many mappings indexing into rowmaps, where we want to key the row by the identity of the object that determines it, but there are two of them.

Instance Variables:

key1	<Object>	One sub-key.
key2	<Object>	The other sub-key.'
"
Class {
	#name : 'RowMapKey',
	#superclass : 'Object',
	#instVars : [
		'key1',
		'key2'
	],
	#category : 'Glorp-UnitOfWork',
	#package : 'Glorp',
	#tag : 'UnitOfWork'
}

{ #category : 'comparing' }
RowMapKey >> = aRowMapKey [

	aRowMapKey class == self class ifFalse: [^false].
	^(key1 == aRowMapKey key1 and: [key2 == aRowMapKey key2]) or: [
		key2 == aRowMapKey key1 and: [key1 == aRowMapKey key2]]
]

{ #category : 'adjusting' }
RowMapKey >> adjustIn: aCorrespondenceMap [
	"Adjust ourselves to refer to the copies rather than the originals"
	| adjusted |
	adjusted := self copy.
	adjusted key1: (aCorrespondenceMap at: key1 ifAbsent: [key1]).
	adjusted key2: (aCorrespondenceMap at: key2 ifAbsent: [key2]).
	^adjusted
]

{ #category : 'comparing' }
RowMapKey >> hash [
	| hash1 hash2 hash1Temp longHash |
	hash1 := key1 identityHash.
	hash2 := key2 identityHash.
	hash1 > hash2 ifTrue: [
		hash1Temp := hash1.
		hash1 := hash2.
		hash2 := hash1Temp].
	longHash := (hash1 bitShift: 8) bitXor: hash2.
	^Dialect fitHashIntoSmallInteger: longHash.
]

{ #category : 'accessing' }
RowMapKey >> key1 [
	^key1
]

{ #category : 'accessing' }
RowMapKey >> key1: anObject [
	key1 := anObject
]

{ #category : 'accessing' }
RowMapKey >> key2 [
	^key2
]

{ #category : 'accessing' }
RowMapKey >> key2: anObject [
	key2 := anObject
]

{ #category : 'adjusting' }
RowMapKey >> reverseAdjustIn: aRowMapForMementos [
	"Adjust ourselves to refer to the copies rather than the originals"
	| adjusted |
	adjusted := self copy.
	adjusted key1: (aRowMapForMementos reversedCorrespondenceMap at: key1 ifAbsent: [key1]).
	adjusted key2: (aRowMapForMementos reversedCorrespondenceMap at: key2 ifAbsent: [key2]).
	^adjusted
]
