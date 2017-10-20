tests
testReadWithObjectEqualityToEmbeddedObject
	| query result |
	 
	[session beginTransaction.
	self writeCustomer1RowsWith2Transactions.
	query := Query
	read: GlorpBankTransaction
	where: [:trans | trans amount = (GlorpMoney currency: #CDN amount: 7)].
	result := session execute: query.
	self assert: result size = 1.
	self assert: result first amount amount = 7.
	self assert: result first amount currency = #CDN] 
			ensure: [session rollbackTransaction]