support
inUnitOfWorkDo: aBlock
	"Set up a bunch of the normal data, read the objects, then run the block in a unit of work"
	self inUnitOfWorkDo: aBlock initializeWith: [self writePersonWithAddress].