tests
testReadWithObjectEqualityToEmbeddedObjectNested
	| query result |
	 
	[session beginTransaction.
	self writeCustomer1RowsWith2Transactions.
	query := Query
		 read: GlorpBankTransaction
	where: [:trans | trans serviceCharge amount = (GlorpMoney currency: #CHF amount: 2)].
	result := session execute: query.
	self assert: result size = 1.
	self assert: result first serviceCharge amount amount = 2.
	self assert: result first serviceCharge amount currency = #CHF] 
			ensure: [session rollbackTransaction]