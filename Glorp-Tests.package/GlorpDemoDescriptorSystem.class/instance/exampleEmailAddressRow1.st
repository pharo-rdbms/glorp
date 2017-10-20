examples
exampleEmailAddressRow1

	| personTable row |
	personTable := self tableNamed: 'EMAIL_ADDRESS'.
	row := DatabaseRow newForTable: personTable.
	row at: (personTable fieldNamed: 'ID') put: 42.
	row at: (personTable fieldNamed: 'USER_NAME') put: 'alan'.
	row at: (personTable fieldNamed: 'HOST_NAME') put: 'objectpeople.com'.
	row at: (personTable fieldNamed: 'PERSON_ID') put: 3.

	^row.