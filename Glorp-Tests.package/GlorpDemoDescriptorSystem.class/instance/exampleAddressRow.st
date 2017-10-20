examples
exampleAddressRow
	| addressTable row |
	addressTable := self  tableNamed: 'GR_ADDRESS'.
	row := DatabaseRow newForTable: addressTable.
	row at: (addressTable fieldNamed: 'ID') put: 123.
	row at: (addressTable fieldNamed: 'STREET') put: 'Paseo Montril'.
	row at: (addressTable fieldNamed: 'HOUSE_NUM') put: '10185'.
	^row