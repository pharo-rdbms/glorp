examples
exampleCALinkRow3

	| linkTable row |
	linkTable := self tableNamed: 'CUSTOMER_ACCT_LINK'.
	row := DatabaseRow newForTable: linkTable.
	row at: (linkTable fieldNamed: 'ACCT_ID') put: 22.
	row at: (linkTable fieldNamed: 'CUSTOMER_ID') put: 28.
	^row.