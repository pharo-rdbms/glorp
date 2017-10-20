api/queries
undelete: anObject ifNotDeleted: aBlock
	| realObject |
	"Get the real object, instantiating if necessary"
	realObject := anObject glorpRealObject.
	self hasUnitOfWork
		ifTrue: [currentUnitOfWork undelete: realObject ifNotDeleted: aBlock]
		ifFalse:
			[self error: 'Can only undelete while the unit of work is in progress'].