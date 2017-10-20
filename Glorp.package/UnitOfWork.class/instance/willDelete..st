deletion
willDelete: anObject
	"Return true if we will delete anObject when we commit."	
	^(deletedObjects includes: anObject) or: [deleting includes: anObject]