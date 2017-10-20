tests
testBeginTransactionWithCommit
	self assert: self accessor isInTransaction not.
	self accessor beginTransaction.
	self assert: self accessor isInTransaction.
	self accessor commitTransaction.
	self assert: self accessor isInTransaction not