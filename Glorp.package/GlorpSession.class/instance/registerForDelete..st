api
registerForDelete: anObject 
	"Register the object with our current unit of work, with intent to delete it."
	| realObject |
	currentUnitOfWork isNil ifTrue: [^self].
	realObject := self realObjectFor: anObject ifNone: [^self].

	currentUnitOfWork registerForDelete: realObject