examples
exampleCustomerRow2

	| customerTable row |
	customerTable := self tableNamed: 'GR_CUSTOMER'.
	row := DatabaseRow newForTable: customerTable.
	row at: (customerTable fieldNamed: 'ID') put: 28.
	row at: (customerTable fieldNamed: 'NAME') put: 'anotherCustomer'.
	^row.