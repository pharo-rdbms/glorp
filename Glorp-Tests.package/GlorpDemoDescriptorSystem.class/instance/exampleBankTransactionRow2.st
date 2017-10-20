examples
exampleBankTransactionRow2
	| table row |
	table := self tableNamed: 'BANK_TRANS'.
	row := DatabaseRow newForTable: table.

	row atFieldNamed: 'ID' put: nil.
	row atFieldNamed: 'OWNER_ID' put: nil.
	row atFieldNamed: 'AMT_CURR' put: 'EUR'.
	row atFieldNamed: 'AMT_AMT' put: 45.
	row atFieldNamed: 'SRVC_DESC' put: 'deposit'.
	row atFieldNamed: 'SRVC_AMT_CURR' put: 'EUR'.
	row atFieldNamed: 'SRVC_AMT_AMT' put: 1.

	^row