examples
exampleAddressRowForOrdering4
	| addressTable row |
	addressTable := self  tableNamed: 'GR_ADDRESS'.
	row := DatabaseRow newForTable: addressTable.
	row at: (addressTable fieldNamed: 'ID') put: 6.
	row at: (addressTable fieldNamed: 'STREET') put: 'Beta'.
	row at: (addressTable fieldNamed: 'HOUSE_NUM') put: '120'.
	^row