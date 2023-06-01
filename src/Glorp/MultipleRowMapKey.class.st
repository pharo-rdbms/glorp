"
This is a special (and rarely needed) form of row map key that allows an arbitrary number of objects to participate in it.
"
Class {
	#name : #MultipleRowMapKey,
	#superclass : #Object,
	#instVars : [
		'keys'
	],
	#category : #'Glorp-UnitOfWork'
}

{ #category : #'*Glorp' }
MultipleRowMapKey class >> new [
	"Answer a newly created and initialized instance."

	^super new initialize
]

{ #category : #'instance creation' }
MultipleRowMapKey class >> with: key1 with: key2 with: key3 [
	(key1 isNil or: [key2 isNil or: [key3 isNil]]) ifTrue: [self error: 'Nil key in row map, probably indicates an invalid object structure'].
	^self new 
		addKey: key1;
		addKey: key2;
		addKey: key3;
		yourself
]

{ #category : #'instance creation' }
MultipleRowMapKey class >> withAll: aCollection [
	
	^self new 
		addAllKeys: aCollection;
		yourself
]

{ #category : #comparing }
MultipleRowMapKey >> = aRowMapKey [

	aRowMapKey class == self class ifFalse: [^false].
	aRowMapKey keys size = keys size ifFalse: [^false].
	"We can't rely on the order being the same because of the obscure but real case of two different related objects with the same identityHash"
	aRowMapKey keys do: [:each |
		(keys includes: each) ifFalse: [^false]].
	^true
]

{ #category : #accessing }
MultipleRowMapKey >> addAllKeys: aKeyCollection [
	keys addAll: aKeyCollection
]

{ #category : #accessing }
MultipleRowMapKey >> addKey: aKey [
	keys add: aKey
]

{ #category : #adjusting }
MultipleRowMapKey >> adjustIn: aCorrespondenceMap [
	"Adjust ourselves to refer to the copies rather than the originals"
	| adjusted |
	adjusted := self copy.
	adjusted keys: (keys collect: [:each | aCorrespondenceMap at: each ifAbsent: [each]]).
	^adjusted
]

{ #category : #comparing }
MultipleRowMapKey >> hash [
	"Note: the two things with the same identity hash problem is OK here because if they do then the hashes are (by definition) the same, and the order doesn't matter"
	| increment hash |
	increment := 14 // keys size.
	hash := 0.
	keys doWithIndex: [:each :index |
		hash := hash bitXor: (each identityHash bitShift: increment * index)].
	^hash
]

{ #category : #initialization }
MultipleRowMapKey >> initialize [
	keys := (SortedCollection new: 4) sortBlock: self sortBlock
]

{ #category : #accessing }
MultipleRowMapKey >> keys [
	^keys
]

{ #category : #accessing }
MultipleRowMapKey >> keys: aCollection [
	keys := (aCollection asSortedCollection: self sortBlock)
]

{ #category : #printing }
MultipleRowMapKey >> printOn: aStream [
	aStream nextPutAll: 'KEY('.
	self hash printOn: aStream.
	aStream nextPutAll: '):'.
	keys printOn: aStream
]

{ #category : #adjusting }
MultipleRowMapKey >> reverseAdjustIn: aRowMapForMementos [
	"Adjust ourselves to refer to the originals rather than the copies"
	| adjusted |
	adjusted := self copy.
	adjusted keys: (keys collect: [:each | 
		aRowMapForMementos reversedCorrespondenceMap at: each ifAbsent: [each]]).
	^adjusted
]

{ #category : #accessing }
MultipleRowMapKey >> sortBlock [
	^[:a :b | a identityHash <= b identityHash]
]
