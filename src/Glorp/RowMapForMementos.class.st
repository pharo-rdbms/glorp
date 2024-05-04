"
This is a specialized version of RowMap for creating rowmaps out of the mementos in the undo/correspondence map. When doing partial writes we create a rowmap for the current state of the objects, then a rowmap for the original state, and difference the two.

The tricky part is that the mementos refer back to the original objects, so when we establish unification constraints between rows, they would establish them to original objects. This is wrong, and not trivial to debug.

So this rowmap keeps the correspondence map and knows that it has to compensate and get the memento for any related objects.

"
Class {
	#name : 'RowMapForMementos',
	#superclass : 'RowMap',
	#instVars : [
		'correspondenceMap',
		'reversedCorrespondenceMap',
		'collectionMementos'
	],
	#category : 'Glorp-UnitOfWork',
	#package : 'Glorp',
	#tag : 'UnitOfWork'
}

{ #category : 'instance creation' }
RowMapForMementos class >> withCorrespondenceMap: aDictionary [

	^self new
		correspondenceMap: aDictionary
]

{ #category : 'api' }
RowMapForMementos >> adjustForMementos: objects [
	"We may be being passed row map keys that refer to originals when they should refer to mementos. Fix.This is horribly ugly."

	1 to: objects size do: [:i | | possibleRowMapKey |
		possibleRowMapKey := objects at: i.
		(self isRowMapKey: possibleRowMapKey) ifTrue: [
			objects at: i put: (possibleRowMapKey adjustIn: correspondenceMap)]].
	^objects
]

{ #category : 'private/mapping' }
RowMapForMementos >> collectionMementoFor: aCollection [

	aCollection glorpIsCollection ifFalse: [^aCollection].
	^collectionMementos at: aCollection ifAbsent: [correspondenceMap at: aCollection]
]

{ #category : 'accessing' }
RowMapForMementos >> collectionMementos: aDictionary [
	collectionMementos := aDictionary
]

{ #category : 'accessing' }
RowMapForMementos >> correspondenceMap [
	^correspondenceMap
]

{ #category : 'accessing' }
RowMapForMementos >> correspondenceMap: anObject [
	correspondenceMap := anObject
]

{ #category : 'api' }
RowMapForMementos >> deleteRowForTable: aTable withKey: aKey ifAbsent: aBlock [
	^super deleteRowForTable: aTable withKey: (self mementoFor: aKey) ifAbsent: aBlock
]

{ #category : 'api' }
RowMapForMementos >> findOrAddRowForTable: aTable withKey: aKey [ 
	^super findOrAddRowForTable: aTable withKey: (self mementoFor: aKey)
]

{ #category : 'api' }
RowMapForMementos >> mementoFor: aKey [
	^(self isRowMapKey: aKey)
		ifTrue: [aKey adjustIn: correspondenceMap]
		ifFalse: [correspondenceMap at: aKey ifAbsent: [aKey]]
]

{ #category : 'private/mapping' }
RowMapForMementos >> originalObjectFor: anObject [

	^correspondenceMap at: anObject
]

{ #category : 'private/mapping' }
RowMapForMementos >> reverseLookup: anObject [

      (self isRowMapKey: anObject) ifTrue: [
            ^anObject reverseAdjustIn: self].
      ^ self reversedCorrespondenceMap at: anObject
]

{ #category : 'api' }
RowMapForMementos >> reversedCorrespondenceMap [
	(reversedCorrespondenceMap isNil
		or: [reversedCorrespondenceMap size ~= correspondenceMap size])
		ifTrue:
			[reversedCorrespondenceMap := IdentityDictionary
				new: correspondenceMap size.
			correspondenceMap
				keysAndValuesDo: [:k :v | reversedCorrespondenceMap at: v put: k]].
	^reversedCorrespondenceMap
]

{ #category : 'api' }
RowMapForMementos >> rowForTable: aTable withKey: aKey ifAbsent: aBlock [
	^super
		rowForTable: aTable
		withKey: (self mementoFor: aKey)
		ifAbsent: aBlock
]
