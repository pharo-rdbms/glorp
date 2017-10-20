examples
exampleAccountRow3

	| accountTable row |
	accountTable := self tableNamed: 'BANK_ACCT'.
	row := DatabaseRow newForTable: accountTable.
	row at: (accountTable fieldNamed: 'ID') put: 22.
	row at: (accountTable fieldNamed: 'BANK_CODE') put: '2'.
	row at: (accountTable fieldNamed: 'BRANCH_NO') put: 712.
	row at: (accountTable fieldNamed: 'ACCT_NO') put: '5551212'.
	^row.