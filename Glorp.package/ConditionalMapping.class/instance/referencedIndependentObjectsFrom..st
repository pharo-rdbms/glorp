mapping
referencedIndependentObjectsFrom: anObject

	| allReferencedObjects |
	allReferencedObjects := OrderedCollection new.
	cases do: [:each | 
		allReferencedObjects addAll: (each value referencedIndependentObjectsFrom: anObject)].
	^allReferencedObjects