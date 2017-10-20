tests
helperForMergedOneToOneReversingWriteOrder: aBoolean 
	| account accountTable row |
	account := GlorpBankExampleSystem new objectNumber: 1 ofClass: GlorpBankAccount.
	accountTable := system tableNamed: 'BANK_ACCT'.
	aBoolean 
		ifTrue: 
			[self write: account.
			self write: account accountNumber]
		ifFalse: 
			[self write: account accountNumber.
			self write: account].
	self assert: (rowMap includesRowForTable: accountTable withKey: account).
	self assert: (rowMap includesRowForTable: accountTable
				withKey: account accountNumber).
	row := self rowFor: account.
	self assert: (row at: (accountTable fieldNamed: 'ID')) = account id.
	(Array with: row with: (self rowFor: account accountNumber)) do: 
			[:each | 
			self assert: (each at: (accountTable fieldNamed: 'BANK_CODE')) 
						= account accountNumber bankCode.
			self assert: (each at: (accountTable fieldNamed: 'BRANCH_NO')) 
						= account accountNumber branchNumber.
			self assert: (each at: (accountTable fieldNamed: 'ACCT_NO')) 
						= account accountNumber accountNumber].
	self assert: (rowMap numberOfEntriesForTable: accountTable) = 2