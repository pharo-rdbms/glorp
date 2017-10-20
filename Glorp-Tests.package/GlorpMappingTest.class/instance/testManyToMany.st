tests
testManyToMany

	| customer customerTable accountTable linkTable linkRow |
	customer := GlorpBankExampleSystem new objectNumber: 1 ofClass: GlorpCustomer.
	rowMap := RowMap new.
	customerTable := system tableNamed: 'GR_CUSTOMER'.
	accountTable := system tableNamed: 'BANK_ACCT'.
	linkTable := system tableNamed: 'CUSTOMER_ACCT_LINK'.

	self write: customer.
	customer accounts do: [:each | 
		self write: each].

	self assert: (rowMap includesRowForTable: customerTable withKey: customer).
	customer accounts do: [:each |
		self assert: (rowMap includesRowForTable: accountTable withKey: each).
		self assert: (rowMap includesRowForTable: linkTable withKey: (RowMapKey new key1: customer; key2: each))].

	customer accounts do: [:each | | rowMapKey |
		self assert: ((self rowFor: each) at: (accountTable fieldNamed: 'ID')) = each id.
		rowMapKey := RowMapKey new key1: customer; key2: each.
		linkRow := rowMap rowForTable: linkTable withKey: rowMapKey.
		self assert: (linkRow at: (linkTable fieldNamed: 'ACCT_ID')) = each id.
		self assert: (linkRow at: (linkTable fieldNamed: 'CUSTOMER_ID')) = customer id.
		].
	self assert: ((self rowFor: customer) at: (customerTable fieldNamed: 'ID')) = customer id.
	self assert: ((rowMap numberOfEntriesForTable: linkTable) = 2).
	self assert: ((rowMap numberOfEntriesForTable: customerTable) = 1).