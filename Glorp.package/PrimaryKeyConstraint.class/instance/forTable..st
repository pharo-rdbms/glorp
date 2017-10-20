initializing
forTable: aTable

	super forTable: aTable.
	name := self primaryKeyConstraintName.
	self primaryKeyFields:  table primaryKeyFields