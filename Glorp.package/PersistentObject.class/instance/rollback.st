actions
rollback
	"Rollback our entries in the queue so that we are not involved in the commit."

	self session hasUnitOfWork ifFalse: [^self].
	self session rollbackUnitOfWorkFor: self