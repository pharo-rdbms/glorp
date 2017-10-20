tests-subselect
testReadCustomerWithEqualitySubSelectToAccountsUsingInClause
	"Test doing a primary key rewrite of the where clause in a subselect, to the result of another subselect"

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyExists: [:eachAccount | eachAccount in: (Query read: GlorpBankAccount where: [:accts2 | accts2 id <> 12])]].
			self assert: customers size = 2.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyExists: [:eachAccount | 
							eachAccount in: (Query read: GlorpBankAccount where: [:accts2 | accts2 id = 22])]].
			self assert: customers size = 1.
			customers do: [:each | each accounts do: [:eachAcct | self assert: eachAcct id = 22]]].