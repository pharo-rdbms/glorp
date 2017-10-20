tests
testDeleteWithEmbedded
	| transaction uow |
	
	[session beginTransaction.
	session beginUnitOfWork.
	self writeCustomer1RowsWithTransactions.
	transaction := (session read: GlorpBankTransaction) first.
	session delete: transaction.
	uow := session privateGetCurrentUnitOfWork.
	self assert: (uow willDelete: transaction).
	self assert: (uow willDelete: transaction amount).
	self assert: (uow willDelete: transaction serviceCharge).
	self assert: (uow willDelete: transaction serviceCharge amount).
	session commitUnitOfWork] 
			ensure: [session rollbackTransaction]