examples
exampleAccountRow1

	| accountTable row |
	accountTable := self tableNamed: 'BANK_ACCT'.
	row := DatabaseRow newForTable: accountTable.
	row at: (accountTable fieldNamed: 'ID') put: 9874.
	row at: (accountTable fieldNamed: 'BANK_CODE') put: '1'.
	row at: (accountTable fieldNamed: 'BRANCH_NO') put: 2.
	row at: (accountTable fieldNamed: 'ACCT_NO') put: '3'.
	^row.