support
setUp
	super setUp.
	a1 := IdentityHashPrintingObject new.
	b1 := IdentityHashPrintingObject new.
	c1 := IdentityHashPrintingObject new.
	transaction := ObjectTransaction new.
	transaction register: a1.
	transaction register: b1.
	transaction register: c1.
	a2 := transaction undoMap at: a1.
	b2 := transaction undoMap at: b1.
	c2 := transaction undoMap at: c1.
	rowMap := RowMapForMementos withCorrespondenceMap: transaction undoMap.
	table1 := DatabaseTable new.
	row1 := 'row1'.
	row2 := 'row2'.