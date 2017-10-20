deletion
delete: anObject
	(self isRegistered: anObject) ifFalse: [session registerForDelete: anObject].
	deletedObjects add: anObject.
	(session embeddedObjectsFor: anObject) do: [:each | self delete: each]