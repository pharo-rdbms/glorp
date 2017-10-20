setup
setUp
	super setUp.
	table := session system tableNamed: 'BANK_TRANS'.
	sequence := (table fieldNamed: 'ID') type sequence.
	row1 := DatabaseRow newForTable: table.
	row2 := DatabaseRow newForTable: table.