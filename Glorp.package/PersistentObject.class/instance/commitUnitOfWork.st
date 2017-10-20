actions
commitUnitOfWork
	"Commit the entire unit of work; this may include objects other than myself."

	self session hasUnitOfWork ifFalse: [^self].
	self session commitUnitOfWork