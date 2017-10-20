tests
testReadWithTrueWhereClause
	| query id1 id2 result accountIds |
	
	[session beginTransaction.
	accountIds := self writeCustomer1Rows.
	id1 := accountIds at: 1.
	id2 := accountIds at: 2.
	query := Query read: GlorpBankAccount
				where: true.
	result := session execute: query.
	self assert: result size = 2] 
			ensure: [session rollbackTransaction]