api
register: anObject
	"Register the object with our current unit of work. We need to do this *before* making changes to the object.  (If an object is read from the database, changed and then registered, and later written back to the database, the pre-registration change may be lost.)"

	| realObject |
	currentUnitOfWork isNil ifTrue: [^self].
	realObject := self realObjectFor: anObject ifNone: [^self].

	(self isNew: realObject) 
		ifTrue: [currentUnitOfWork registerAsNew: realObject]
		ifFalse: [currentUnitOfWork register: realObject].