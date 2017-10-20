tests
testReadCustomerWithAnySatisfyExists
	| query result accounts |
	
	[session beginTransaction.
	self writeCustomer1Rows.
	query := Query read: GlorpCustomer
				where: 
					[:person | 
					person accounts anySatisfyExists: [:each | each accountNumber branchNumber > 0]].
	result := session execute: query.
	self assert: result size = 1.
	accounts := result first accounts getValue.
	self assert: accounts size = 2.
	query := Query read: GlorpCustomer
				where: 
					[:person | 
					person accounts anySatisfy: [:each | each accountNumber branchNumber = 2]].
	result := session execute: query.
	self assert: result size = 1.
	accounts := result first accounts getValue.
	self assert: accounts size = 2] 
			ensure: [session rollbackTransaction]