api/transactions
beginUnitOfWork
	"Start a UnitOfWork, to organize your updates."

	self hasUnitOfWork ifTrue: [self error: 'Cannot nest units of work yet'].
	currentUnitOfWork := UnitOfWork new.
	currentUnitOfWork session: self.