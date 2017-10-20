support
writeCustomer1RowsWithTransactions
	| table row aGlorpDemoDescriptorSystem |
	self writeCustomer1Rows.
	aGlorpDemoDescriptorSystem := session system.
	table := aGlorpDemoDescriptorSystem tableNamed: 'BANK_TRANS'.
	row := DatabaseRow newForTable: table.
	row atFieldNamed: 'ID' put: nil.
	row atFieldNamed: 'AMT_CURR' put: 'CDN'.
	row atFieldNamed: 'AMT_AMT' put: 7.
	row atFieldNamed: 'SRVC_DESC' put: 'additional overcharge'.
	row atFieldNamed: 'SRVC_AMT_CURR' put: 'USD'.
	row atFieldNamed: 'SRVC_AMT_AMT' put: 2.
	row atFieldNamed: 'OWNER_ID' put: 27.
	session writeRow: row.