examples
exampleCALinkRow1

	| linkTable row |
	linkTable := self tableNamed: 'CUSTOMER_ACCT_LINK'.
	row := DatabaseRow newForTable: linkTable.
	row at: (linkTable fieldNamed: 'ACCT_ID') put: 9874.
	row at: (linkTable fieldNamed: 'CUSTOMER_ID') put: 27.
	^row.