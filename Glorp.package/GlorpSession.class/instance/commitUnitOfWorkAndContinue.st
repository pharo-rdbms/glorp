api/transactions
commitUnitOfWorkAndContinue
	"Commit the current unit of work, but then keep going with the same set of registered objects, with their state updated to reflect current values."
	| registeredObjects |	
	currentUnitOfWork isNil ifTrue: [^self error: 'Not in unit of work'].
	registeredObjects := currentUnitOfWork registeredObjects.
	currentUnitOfWork deletedObjects do: [:each | registeredObjects remove: each].
	self commitUnitOfWork.
	self beginUnitOfWork.
	self registerAll: registeredObjects.