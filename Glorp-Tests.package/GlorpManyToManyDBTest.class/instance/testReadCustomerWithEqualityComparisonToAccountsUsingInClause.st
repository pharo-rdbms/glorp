tests-subselect
testReadCustomerWithEqualityComparisonToAccountsUsingInClause
	"Test doing a primary key rewrite of the where clause in a subselect, to the result of another subselect"

	| customers accounts |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			accounts := session read: GlorpBankAccount where: [:each | each id = 22].
			customers := session
				read: GlorpCustomer
				where:
					[:eachCustomer | 
					eachCustomer accounts
						anySatisfyExists: [:eachAccount | eachAccount in: accounts]].
			self assert: customers size = 1.
			customers do: [:each | each accounts do: [:eachAcct | self assert: eachAcct id = 22]]].