tests-write
testWriteCustomersAndAccountsAndDelete
	| newCustomer1 newCustomer2 newCustomer3 joint withBaby1 withBaby2 hisChecking herChecking |
	self
		inTransactionDo:
			[
			session beginUnitOfWork.
			newCustomer1 := GlorpCustomer exampleD1.
			newCustomer2 := GlorpCustomer exampleD2.
			newCustomer3 := GlorpCustomer exampleD3.
			hisChecking := GlorpBankAccount new id: 301.
			herChecking := GlorpBankAccount new id: 302.
			joint := GlorpBankAccount new id: 303.
			withBaby1 := GlorpBankAccount new id: 304.
			withBaby2 := GlorpBankAccount new id: 305.
			newCustomer1 id: 201; accounts: (OrderedCollection with: hisChecking with: joint with: withBaby1).
			newCustomer2 id: 202; accounts: (OrderedCollection with: herChecking with: joint with: withBaby2).
			newCustomer3 id: 203; accounts: (OrderedCollection with: withBaby1 with: withBaby2).
			session register: newCustomer1;
				register: newCustomer2;
				register: newCustomer3.
			session commitUnitOfWork.
			session reset.
			newCustomer1 := self readCustomer: 201.
			self assert: newCustomer1 accounts size = 3.
			newCustomer2 := self readCustomer: 202.
			self assert: newCustomer2 accounts size = 3.
			newCustomer3 := self readCustomer: 203.
			self assert: newCustomer3 accounts size = 2.
			self checkNumberOfAccounts: 5.
			self checkNumberOfLinkRows: 8.
			session reset.	
			session transact: [ | cust acct |		
				cust := self readCustomer: 201.
				acct := cust accounts detect: [:ea| ea id = 301] ifNone: [nil].
				acct notNil ifTrue: [session delete: acct].
				session delete: cust].
			self checkNumberOfAccounts: 4.
			self checkNumberOfLinkRows: 5].