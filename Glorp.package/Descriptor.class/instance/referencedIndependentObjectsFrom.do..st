internal
referencedIndependentObjectsFrom: anObject do: aBlock

	mappings do: [:each |
		(each referencedIndependentObjectsFrom: anObject) do: [:eachReferencedObject |
			aBlock value: eachReferencedObject]]