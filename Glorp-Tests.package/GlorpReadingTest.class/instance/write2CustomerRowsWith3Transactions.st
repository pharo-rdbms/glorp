support
write2CustomerRowsWith3Transactions
	| table row aGlorpDemoDescriptorSystem |
	session system writeCustomerWithDualAccountOwners.
	aGlorpDemoDescriptorSystem := session system.
	table := aGlorpDemoDescriptorSystem tableNamed: 'BANK_TRANS'.
	row := DatabaseRow newForTable: table.
	row atFieldNamed: 'ID' put: nil.
	row atFieldNamed: 'AMT_CURR' put: 'CDN'.
	row atFieldNamed: 'AMT_AMT' put: 9.
	row atFieldNamed: 'SRVC_DESC' put: 'additional overcharge'.
	row atFieldNamed: 'SRVC_AMT_CURR' put: 'CHF'.
	row atFieldNamed: 'SRVC_AMT_AMT' put: 2.
	row atFieldNamed: 'OWNER_ID' put: 27.
	session writeRow: row.
	row := DatabaseRow newForTable: table.
	row atFieldNamed: 'ID' put: nil.
	row atFieldNamed: 'AMT_CURR' put: 'USD'.
	row atFieldNamed: 'AMT_AMT' put: 10.
	row atFieldNamed: 'SRVC_DESC' put: 'additional overcharge'.
	row atFieldNamed: 'SRVC_AMT_CURR' put: 'CHF'.
	row atFieldNamed: 'SRVC_AMT_AMT' put: 2.
	row atFieldNamed: 'OWNER_ID' put: 27.
	session writeRow: row.
	row := DatabaseRow newForTable: table.
	row atFieldNamed: 'ID' put: nil.
	row atFieldNamed: 'AMT_CURR' put: 'EUR'.
	row atFieldNamed: 'AMT_AMT' put: 11.
	row atFieldNamed: 'SRVC_DESC' put: 'additional overcharge'.
	row atFieldNamed: 'SRVC_AMT_CURR' put: 'EUR'.
	row atFieldNamed: 'SRVC_AMT_AMT' put: 2.
	row atFieldNamed: 'OWNER_ID' put: 28.
	session writeRow: row.