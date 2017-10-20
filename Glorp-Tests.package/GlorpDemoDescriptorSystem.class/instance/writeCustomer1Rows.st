support
writeCustomer1Rows
	| linkRow2 id2 id1 accountRow1 customerRow accountRow2 linkRow1 |
	customerRow := self exampleCustomerRow1.
	accountRow1 := self exampleAccountRow1.
	accountRow2 := self exampleAccountRow2.
	linkRow1 := self exampleCALinkRow1.
	linkRow2 := self exampleCALinkRow2.
	session writeRow: customerRow.
	session writeRow: accountRow1.
	session writeRow: accountRow2.
	session writeRow: linkRow1.
	session writeRow: linkRow2.
	id1 := accountRow1 at: (accountRow1 table fieldNamed: 'ID').
	id2 := accountRow2 at: (accountRow2 table fieldNamed: 'ID').
	^Array with: id1 with: id2.