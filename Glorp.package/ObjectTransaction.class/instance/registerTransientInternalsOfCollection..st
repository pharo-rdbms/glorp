registering
registerTransientInternalsOfCollection: aCollection
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