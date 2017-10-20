configuring
table: aDatabaseTable
	table := aDatabaseTable.
	contents := Array new: (aDatabaseTable fields size).
	contents atAllPut: self class emptySlot.