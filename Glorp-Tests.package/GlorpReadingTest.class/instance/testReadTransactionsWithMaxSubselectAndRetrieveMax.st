tests
testReadTransactionsWithMaxSubselectAndRetrieveMax
	| query result |
	
	[session beginTransaction.
	self write2CustomerRowsWith3Transactions.
	query := Query read: GlorpBankTransaction where: [:each |
		each amount amount = ((Query read: GlorpBankTransaction
			where: [:eachTrans | eachTrans owner = each owner]) 
				retrieveMax: [:eachTrans | eachTrans amount amount])].
	query orderBy: [:each | each owner name].
	result := session execute: query.
	self assert: result size = 2.
	self assert: result first amount amount = 10.
	self assert: result last amount amount = 11.
	self assert: result first owner id ~= result last owner id] 
			ensure: [session rollbackTransaction]