api/transactions
save: anObject 
	"Make sure anObject will be written to the database by starting a unit of work if we aren't already in one, and registering the object. This is in most ways the same as just registering an object, but it tells us to disregard whether/how the object has changed and to save all of its fields. This is useful if we need to register an object *after* changes have occurred, and can be used to implement something more like an object by object save facility. Still somewhat experimental."
	| realObject |
	realObject := self realObjectFor: anObject ifNone: [^self].
	
	self hasUnitOfWork
		ifTrue:	[currentUnitOfWork registerAsNew: realObject]
		ifFalse:
			[self inUnitOfWorkDo: [
				currentUnitOfWork registerAsNew: realObject]]