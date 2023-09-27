"
An ObjectTransaction knows how to remember the state of objects and revert them back to that state later on. It does this by making a *shallow* copy of the registered objects and everything connected to them, and then putting that into an identity dictionary keyed by the originals.

If you have to undo, you push the state from the shallow copies back into the originals.

Yes, that works, and it's all you have to do. It even handles collections become:ing different sizes.

This is fairly independent of GLORP. You could use this mechanism in general, if you provided your own mechanism for figuring out what to register, or even just uncommented the one in here.

Instance Variables:
	undoMap	<IdentityDictionary>	 The dictionary of originals->copies.


"
Class {
	#name : #ObjectTransaction,
	#superclass : #Object,
	#instVars : [
		'undoMap',
		'collectionMementos'
	],
	#category : #'Glorp-UnitOfWork'
}

{ #category : #'begin/commit/abort' }
ObjectTransaction >> abort [
	undoMap keysAndValuesDo: [:original :copy | self restoreStateOf: original toThatOf: copy]
]

{ #category : #'begin/commit/abort' }
ObjectTransaction >> abort: original [
	| copy |
	copy := undoMap at: original ifAbsent: [^self].
	self restoreStateOf: original toThatOf: copy
]

{ #category : #'begin/commit/abort' }
ObjectTransaction >> begin [
	self initializeUndoMap
]

{ #category : #accessing }
ObjectTransaction >> collectionMementoFor: anObject [
	anObject isNil ifTrue: [^#()].
	^collectionMementos at: anObject ifAbsent: [self mementoFor: anObject]
]

{ #category : #accessing }
ObjectTransaction >> collectionMementos [
	^collectionMementos
]

{ #category : #'begin/commit/abort' }
ObjectTransaction >> commit [
	self initializeUndoMap
]

{ #category : #initialization }
ObjectTransaction >> initialize [
	self initializeUndoMap.
]

{ #category : #initialization }
ObjectTransaction >> initializeUndoMap [

	undoMap := IdentityDictionary new: 1000.
	collectionMementos := IdentityDictionary new: 200
]

{ #category : #registering }
ObjectTransaction >> isRegistered: anObject [ 
	"Note: We can never have a situation where a proxy is registered but its contents aren't, so we don't have to worry about that ambiguous case."
	| realObject |
	realObject := self realObjectFor: anObject ifNone: [^false].
	^undoMap includesKey: realObject
]

{ #category : #'private/restoring' }
ObjectTransaction >> isShapeOf: original differentThanThatOf: copy [

	^original class ~~ copy class or: [original glorpBasicSize ~= copy glorpBasicSize]
]

{ #category : #accessing }
ObjectTransaction >> mementoFor: anObject [
	^undoMap at: anObject
]

{ #category : #registering }
ObjectTransaction >> needsCollectionMementoFor: aCollection [
	"We can avoid the need for a collection copy if the collection has no internal structure - that is, if we'll be able to loop over a simple shallow copy. This is dialect and collection class dependent"
	^Dialect needsCollectionMementoFor: aCollection
]

{ #category : #registering }
ObjectTransaction >> realObjectFor: anObject [ 
	"If this is a proxy, return the contents (if available). Otherwise, return nil"
	^self realObjectFor: anObject ifNone: [nil]
]

{ #category : #registering }
ObjectTransaction >> realObjectFor: anObject ifNone: aBlock [
	"If this is a proxy, return the contents (if available). Otherwise, evaluate the block"
	^anObject isGlorpProxy 
		ifTrue: [anObject isInstantiated ifTrue: [anObject getValue] ifFalse: [aBlock value]]
		ifFalse: [anObject]
]

{ #category : #registering }
ObjectTransaction >> register: anObject [ 
	"Make anObject be a member of the current transaction. Return the object if registered, or nil otherwise"

	| copy realObject |
	(self requiresRegistrationFor: anObject) ifFalse: [^nil].
	realObject := self realObjectFor: anObject ifNone: [^nil].
	copy := self shallowCopyOf: realObject ifNotNeeded: [^nil].
	undoMap at: realObject put: copy.
	self registerTransientInternalsOfCollection: realObject.
	^realObject
]

{ #category : #registering }
ObjectTransaction >> registerTransientInternalsOfCollection: aCollection [
	"If this is a collection, then we may need to register any internal structures it has, e.g. an internal array. This is implementation dependent for the collection. We will also explicitly exclude strings"

	aCollection glorpIsCollection ifFalse: [^self].
	aCollection class isBits ifTrue: [^self].
	(self needsCollectionMementoFor: aCollection)
		ifTrue: [collectionMementos at: aCollection put: aCollection copy].
	aCollection glorpRegisterCollectionInternalsIn: self

"For this to work, the dialect must not copy collections so shallowly that internals are reused identically.
In VW, Dictionary copy calls postCopy, which copies the associations or value collection (but not the
keys).  Without this, mementos added to the original would also be added to the copy.  In VA, sending
copy to a Dictionary does a shallow copy.  In VA, inline the call of copy to shallowCopy and send the
postCopy call to it explicitly to get the behaviour we need without changing Dictionary copy behaviour
in VA, which might have side-effects.  This feature's tests have been altered to check this copy safety."
]

{ #category : #registering }
ObjectTransaction >> registeredObjectsDo: aBlock [
	"Iterate over all our objects. Note that this will include objects without descriptors. Be sure we're iterating over a copy of the keys, because this will add objects to the undoMap. Allow the block to return a collection which we will then add to the list of things to process, until there's nothing further"

	| newAdditions previousVersion |
	newAdditions := undoMap keys.
	previousVersion := newAdditions asSet.
	[newAdditions isEmpty]
		whileFalse:
			[newAdditions do: aBlock.
			newAdditions := OrderedCollection new.
			undoMap
				keysDo:
					[:eachKey | (previousVersion includes: eachKey) ifFalse: [newAdditions add: eachKey]].
			newAdditions isEmpty ifFalse: [previousVersion := undoMap keys asSet]
				]
]

{ #category : #registering }
ObjectTransaction >> requiresRegistrationFor: anObject [

	| realObject |
	realObject := self realObjectFor: anObject ifNone: [^false].
	^(self isRegistered: realObject) not
]

{ #category : #'private/restoring' }
ObjectTransaction >> restoreIndexedInstanceVariablesOf: original toThoseOf: copy [

	copy glorpStartOfIndexedInstVars to: copy glorpEndOfIndexedInstVars do: [:index |
		original isString 
			ifTrue: [original at: index put: (copy at: index)]
			ifFalse: [original basicAt: index put: (copy basicAt: index)]]
]

{ #category : #'private/restoring' }
ObjectTransaction >> restoreNamedInstanceVariablesOf: original toThoseOf: copy [

	1 to: copy class instSize do: [:index |
		original instVarAt: index put: (copy instVarAt: index)]
]

{ #category : #'private/restoring' }
ObjectTransaction >> restoreShapeOf: original toThatOf: copy [

	| newOriginal |
	(copy class isBits or: [copy class isVariable])
		ifTrue: [newOriginal := copy class basicNew: copy glorpBasicSize]
		ifFalse: [newOriginal := copy class basicNew].
	original become: newOriginal
]

{ #category : #'private/restoring' }
ObjectTransaction >> restoreStateOf: original toThatOf: copy [ 

	(self isShapeOf: original differentThanThatOf: copy) 
		ifTrue: [self restoreShapeOf: original toThatOf: copy].
	self restoreNamedInstanceVariablesOf: original toThoseOf: copy.
	self restoreIndexedInstanceVariablesOf: original toThoseOf: copy
]

{ #category : #'private/registering' }
ObjectTransaction >> shallowCopyOf: anObject ifNotNeeded: aBlock [

	| copy |
	copy := anObject shallowCopy.
	^copy == anObject 
		ifTrue: [aBlock value]
		ifFalse: [copy]
]

{ #category : #accessing }
ObjectTransaction >> undoMap [
	^undoMap
]
