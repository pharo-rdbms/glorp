building objects
registerObjectInUnitOfWork
	"If there is a current unit of work, then we must register in it, after population because that way the state is already in place. The nil checks are mostly for safety during unit tests, as those conditions should never occur in real use"
	query isNil ifTrue: [^self].
	query session isNil ifTrue: [^self].
	query session register: instance.