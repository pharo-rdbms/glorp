private
privateRegisterAsOld: anObject 
	"Register the object as something we already read from the database, skipping the isNew: test. Private! Normally you would just use register:"
	| realObject |
	currentUnitOfWork isNil ifTrue: [^self].
	realObject := self realObjectFor: anObject ifNone: [^self].

	currentUnitOfWork register: realObject