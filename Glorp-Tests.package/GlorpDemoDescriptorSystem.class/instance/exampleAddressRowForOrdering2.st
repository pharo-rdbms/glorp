examples
exampleAddressRowForOrdering2
	| addressTable row |
	addressTable := self  tableNamed: 'GR_ADDRESS'.
	row := DatabaseRow newForTable: addressTable.
	row at: (addressTable fieldNamed: 'ID') put: 2.
	row at: (addressTable fieldNamed: 'STREET') put: 'Beta'.
	row at: (addressTable fieldNamed: 'HOUSE_NUM') put: '200'.
	^row