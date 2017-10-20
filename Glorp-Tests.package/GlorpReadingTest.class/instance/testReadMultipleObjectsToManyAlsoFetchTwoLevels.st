tests
testReadMultipleObjectsToManyAlsoFetchTwoLevels
	| query result account transactions |
	
	[session beginTransaction.
	self write2CustomerRowsWith3Transactions.
	session beginUnitOfWork.

	query := Query read: GlorpBankAccount.
	query alsoFetch: [:each | each accountHolders].
	query alsoFetch: [:each | each accountHolders transactions].
	result := query executeIn: session.
	self assert: result size = 2.
	account := result detect: [:each | each id = 9874].
	self deny: result first == result last.
	self deny: account accountHolders isGlorpProxy.
	self assert: account accountHolders size = 1.
	transactions := account accountHolders first transactions.
	self deny: transactions isGlorpProxy.
	self assert: transactions size = 2.
	self assert: account accountHolders first == (result at: 2) accountHolders first] 
			ensure: [session rollbackTransaction]