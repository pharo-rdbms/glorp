examples
exampleAddressRowForOrdering5
	| addressTable row |
	addressTable := self  tableNamed: 'GR_ADDRESS'.
	row := DatabaseRow newForTable: addressTable.
	row at: (addressTable fieldNamed: 'ID') put: 4.
	row at: (addressTable fieldNamed: 'STREET') put: 'Beta'.
	row at: (addressTable fieldNamed: 'HOUSE_NUM') put: '130'.
	^row