tests-link table
writeCustomersWithOneAccountEach
	| customerRow accountRow1 accountRow2 linkRow1 linkRow2 customerRow2 |

	customerRow := session system exampleCustomerRow1.
	customerRow2 := session system exampleCustomerRow2.
	accountRow1 := session system exampleAccountRow1. 
	accountRow2 := session system exampleAccountRow3.
	linkRow1 := session system exampleCALinkRow1.
	linkRow2 := session system exampleCALinkRow3.
	session writeRow: customerRow.
	session writeRow: customerRow2.
	session writeRow: accountRow1.
	session writeRow: accountRow2.
	session writeRow: linkRow1.
	session writeRow: linkRow2.