tests
testOneToMany

	| customer customerTable transactionTable |
	customer := GlorpCustomer example1.
	rowMap := RowMap new.
	customerTable := system tableNamed: 'GR_CUSTOMER'.
	transactionTable := system tableNamed: 'BANK_TRANS'.
	self write: customer.
	customer transactions do: [:each |
		self write: each].

	self assert: (rowMap includesRowForTable: customerTable withKey: customer).
	customer transactions do: [:each |
		self assert: (rowMap includesRowForTable: transactionTable withKey: each)].

	customer transactions do: [:each |
		self assert: ((self rowFor: each) at: (transactionTable fieldNamed: 'OWNER_ID')) = customer id].
	self assert: ((self rowFor: customer) at: (customerTable fieldNamed: 'ID')) = customer id.