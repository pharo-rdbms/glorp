tests
testReadCustomerWithMultipleAnySatisfyExists
	| query result |
	
	[| block |
	session beginTransaction.
	self writeCustomer1Rows.
	block := 
			[:person | 
			(person accounts anySatisfyExists: [:each | each accountNumber branchNumber = 2]) 
				& (person accounts 
						anySatisfyExists: [:each | each accountNumber branchNumber = 3])].
	query := Query read: GlorpCustomer where: block.
	result := session execute: query.
	self assert: result size = 1] 
			ensure: [session rollbackTransaction]