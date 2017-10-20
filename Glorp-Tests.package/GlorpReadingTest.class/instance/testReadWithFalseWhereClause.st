tests
testReadWithFalseWhereClause
	| query id1 id2 result accountIds |
	
	[session beginTransaction.
	accountIds := self writeCustomer1Rows.
	id1 := accountIds at: 1.
	id2 := accountIds at: 2.
	query := Query read: GlorpBankAccount
				where: false.
	result := session execute: query.
	self assert: result size = 0] 
			ensure: [session rollbackTransaction]