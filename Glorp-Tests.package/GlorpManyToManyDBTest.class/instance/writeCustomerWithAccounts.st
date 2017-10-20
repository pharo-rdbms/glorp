support
writeCustomerWithAccounts
	| customerRow accountRow1 accountRow2 linkRow1 linkRow2 customerRow2 accountRow3 linkRow3 |

	customerRow := session system exampleCustomerRow1.
	customerId := customerRow atFieldNamed: 'ID'.
	customerRow2 := session system exampleCustomerRow2.
	accountRow1 := session system exampleAccountRow1. 
	accountId2 := accountRow1 atFieldNamed: 'ID'.
	accountRow2 := session system exampleAccountRow2.
	accountId1 := accountRow2 atFieldNamed: 'ID'.
	accountRow3 := session system exampleAccountRow3.
	linkRow1 := session system exampleCALinkRow1.
	linkRow2 := session system exampleCALinkRow2.
	linkRow3 := session system exampleCALinkRow3.
	session writeRow: customerRow.
	session writeRow: customerRow2.
	session writeRow: accountRow1.
	session writeRow: accountRow2.
	session writeRow: accountRow3.
	session writeRow: linkRow1.
	session writeRow: linkRow2.
	session writeRow: linkRow3.