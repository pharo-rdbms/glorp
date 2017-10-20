examples
exampleCustomerRow1

	| customerTable row |
	customerTable := self tableNamed: 'GR_CUSTOMER'.
	row := DatabaseRow newForTable: customerTable.
	row at: (customerTable fieldNamed: 'ID') put: 27.
	row at: (customerTable fieldNamed: 'NAME') put: 'aCustomer'.
	^row.