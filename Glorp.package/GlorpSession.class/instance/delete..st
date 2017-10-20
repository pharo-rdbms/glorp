api/queries
delete: anObject
	| realObject |
	"Get the real object, instantiating if necessary"
	realObject := anObject glorpRealObject.
	self hasUnitOfWork
		ifTrue: [currentUnitOfWork delete: realObject]
		ifFalse:
			[self inUnitOfWorkDo: [
				currentUnitOfWork delete: realObject]]