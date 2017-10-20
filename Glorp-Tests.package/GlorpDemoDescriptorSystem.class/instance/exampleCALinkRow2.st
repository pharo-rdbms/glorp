examples
exampleCALinkRow2

	| linkTable row |
	linkTable := self tableNamed: 'CUSTOMER_ACCT_LINK'.
	row := DatabaseRow newForTable: linkTable.
	row at: (linkTable fieldNamed: 'ACCT_ID') put: 6.
	row at: (linkTable fieldNamed: 'CUSTOMER_ID') put: 27.
	^row.