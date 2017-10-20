tests
testReadEmbeddedObjectDirectly
	| serviceCharges transRow |
	
	[
	session beginTransaction.
	transRow := session system exampleBankTransactionRow.
	session writeRow: transRow.
	transRow := session system exampleBankTransactionRow2.
	session writeRow: transRow.
	serviceCharges := session read: GlorpServiceCharge.
	self assert: serviceCharges size = 2.
	self deny: serviceCharges first == serviceCharges last.
	] 
			ensure: [session rollbackTransaction]