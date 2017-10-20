tests-link table
testLinkTableWrite
	system := GlorpLinkTableAnywhereDescriptorSystem
		forPlatform: system platform.
	session system: system.
	self
		inTransactionDo:
			[| rows row |
			self
				inUnitOfWorkDo:
					[| cust1 acct1 |
					cust1 := GlorpCustomer new.
					cust1 id: 2.
					cust1 name: 'Violet Baudelaire'.
					acct1 := GlorpBankAccount new.
					acct1 id: 3.
					cust1 accounts: acct1.
					session register: cust1].
			session reset.
			rows := session accessor
				executeSQLString:
					'select * from GR_CUSTOMER t1, BANK_ACCT t2, CUSTOMER_ACCT_LINK t3 WHERE t3.ACCT_ID = t2.ID AND t3.CUSTOMER_ID = t1.ID'.
			self assert: rows size = 1.
			row := rows first.
			self assert: (row asArray = (OrderedCollection new add: 2; add: 'Violet Baudelaire'; add: 3; add: nil; add: nil; add: nil; add: 2; add: 3; yourself) asArray)].