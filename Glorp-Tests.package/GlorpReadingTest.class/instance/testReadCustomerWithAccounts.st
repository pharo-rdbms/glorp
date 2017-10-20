tests
testReadCustomerWithAccounts
	| query id1 id2 result accounts backRef1 backRef2 accountIds |
	
	[session beginTransaction.
	accountIds := self writeCustomer1Rows.
	id1 := accountIds at: 1.
	id2 := accountIds at: 2.
	query := Query readOneOf: GlorpCustomer
				where: [:person | person id = 27].
	result := session execute: query.
	self assert: result seenPostFetch = true.
	accounts := result accounts getValue.
	self assert: accounts size = 2.
	self assert: (accounts first id = id1 or: [accounts last id = id1]).
	self assert: (accounts first id = id2 or: [accounts last id = id2]).
	self assert: accounts first id ~= accounts last id.
	backRef1 := accounts first accountHolders getValue.
	self assert: backRef1 size = 1.
	self assert: backRef1 first = result.
	backRef2 := accounts first accountHolders getValue.
	self assert: backRef2 size = 1.
	self assert: backRef2 first = result] 
			ensure: [session rollbackTransaction]