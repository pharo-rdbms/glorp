api
forceSaveOf: anObject 
	"This is the same as registering an object, but it tells us to disregard whether/how the object has changed and to save all of its fields. This is useful if we need to register an object after changes have occurred, and can be used to implement something more like an object by object save facility. Still somewhat experimental."
	| realObject |
	realObject := self realObjectFor: anObject ifNone: [^self].
	
	self inUnitOfWorkDo: [currentUnitOfWork registerAsNew: realObject]