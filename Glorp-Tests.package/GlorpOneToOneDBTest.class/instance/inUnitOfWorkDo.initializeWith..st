support
inUnitOfWorkDo: aBlock initializeWith: initBlock
	"Set up a bunch of the normal data, read the objects, then run the block in a unit of work"
	initBlock value.
	session beginUnitOfWork.
	self readPerson.
	aBlock value.
	session commitUnitOfWork.
	session reset.