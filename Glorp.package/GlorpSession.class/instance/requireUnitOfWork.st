api/transactions
requireUnitOfWork
	"Start a unit of work if there isn't one already."
	self hasUnitOfWork ifFalse: [self beginUnitOfWork].