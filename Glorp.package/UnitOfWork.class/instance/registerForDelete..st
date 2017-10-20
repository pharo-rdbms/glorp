registering
registerForDelete: anObject 
	"Register anObject with intent to delete it."
	[deleting add: anObject.
	self register: anObject] ensure: [deleting remove: anObject ifAbsent: []]