examples
exampleEmailAddressRow2

	| personTable row |
	personTable := self tableNamed: 'EMAIL_ADDRESS'.
	row := DatabaseRow newForTable: personTable.
	row at: (personTable fieldNamed: 'ID') put: 54321.
	row at: (personTable fieldNamed: 'USER_NAME') put: 'johnson'.
	row at: (personTable fieldNamed: 'HOST_NAME') put: 'cs.uiuc.edu'.
	row at: (personTable fieldNamed: 'PERSON_ID') put: 3.
	^row.