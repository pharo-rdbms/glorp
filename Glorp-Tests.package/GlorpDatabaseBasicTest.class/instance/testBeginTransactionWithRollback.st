tests
testBeginTransactionWithRollback
	self assert: self accessor isInTransaction not.
	self accessor beginTransaction.
	self assert: self accessor isInTransaction.
	self accessor rollbackTransaction.
	self assert: self accessor isInTransaction not