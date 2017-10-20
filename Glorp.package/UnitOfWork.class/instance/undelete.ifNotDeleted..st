deletion
undelete: anObject ifNotDeleted: aBlock
	deletedObjects remove: anObject ifAbsent: aBlock.
	(session embeddedObjectsFor: anObject) do: [:each | self undelete: each]