support
setUp
	super setUp.
	a1 := IdentityHashPrintingObject new.
	b1 := IdentityHashPrintingObject new.
	rowMap := RowMap new.
	table1 := DatabaseTable new name: 'SomeTable'.
	platform := OraclePlatform new.
	table1 addField: (DatabaseField named: 'ONE_ID' type: platform integer) bePrimaryKey.
	table1 addField: (DatabaseField named: 'OTHER_ID' type: platform integer).
	table1 addField: (DatabaseField named: 'KEY' type: platform integer) bePrimaryKey.
	row2 := 'row2'.