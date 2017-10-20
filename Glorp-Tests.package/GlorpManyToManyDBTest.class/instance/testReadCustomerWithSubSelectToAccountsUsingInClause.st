tests-subselect
testReadCustomerWithSubSelectToAccountsUsingInClause
	"Test doing an IN clause with the result of another subselect"

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyExists: [:eachAccount | 
							| q |
							q := Query read: GlorpBankAccount where: [:accts2 | accts2 id <> 12].
							q retrieve: #id.
							eachAccount id in: q]].
			self assert: customers size = 2.
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyExists: [:eachAccount | 
							| q |
							q := Query read: GlorpBankAccount where: [:accts2 | accts2 id = 22].
							q retrieve: #id.
							eachAccount id in: q]].
			self assert: customers size = 1.
			customers do: [:each | each accounts do: [:eachAcct | self assert: eachAcct id = 22]].
].