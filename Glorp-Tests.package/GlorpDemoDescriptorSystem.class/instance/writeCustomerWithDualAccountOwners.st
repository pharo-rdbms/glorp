support
writeCustomerWithDualAccountOwners
	| linkRow2 id2 id1 accountRow1 accountRow2 linkRow1 customer1Row customer2Row linkRow4 |
	customer1Row := self exampleCustomerRow1.
	customer2Row := self exampleCustomerRow2.
	accountRow1 := self exampleAccountRow1.
	accountRow2 := self exampleAccountRow2.
	linkRow1 := self exampleCALinkRow1.
	linkRow2 := self exampleCALinkRow2.
	linkRow4 := self exampleCALinkRow4.
	session writeRow: customer1Row.
	session writeRow: customer2Row.
	session writeRow: accountRow1.
	session writeRow: accountRow2.
	session writeRow: linkRow1.
	session writeRow: linkRow2.
	session writeRow: linkRow4.
	id1 := accountRow1 at: (accountRow1 table fieldNamed: 'ID').
	id2 := accountRow2 at: (accountRow2 table fieldNamed: 'ID').
	^Array with: id1 with: id2.