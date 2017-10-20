examples
exampleAddressRowForOrdering1
	| addressTable row |
	addressTable := self  tableNamed: 'GR_ADDRESS'.
	row := DatabaseRow newForTable: addressTable.
	row at: (addressTable fieldNamed: 'ID') put: 1.
	row at: (addressTable fieldNamed: 'STREET') put: 'Alpha'.
	row at: (addressTable fieldNamed: 'HOUSE_NUM') put: '300'.
	^row