support
setUp
	| accountRow3 |
	super setUp.
	session beginTransaction.
	system writeCustomer1Rows.
	accountRow3 := system exampleAccountRow3.
	session writeRow: accountRow3.