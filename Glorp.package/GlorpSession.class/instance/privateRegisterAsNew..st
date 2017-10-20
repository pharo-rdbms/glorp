private
privateRegisterAsNew: anObject 
	"Register the object as one which is not already in cache. Private! Normally just use the register: operation."
	currentUnitOfWork isNil ifTrue: [^self].
	currentUnitOfWork registerAsNew: anObject