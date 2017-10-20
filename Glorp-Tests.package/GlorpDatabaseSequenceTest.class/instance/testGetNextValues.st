tests
testGetNextValues
	"If the platform supportsSettingSequenceIncrement then the increment will be computed in the image within each range and only got from the database at the start of each range (i.e. at 1, 4, 7 and 10, since this test's increment is 3 at time of writing - see tableForBANK_TRANS:) in method nextSequenceNumber:."

	| rows thisID nextID |
	session platform usesIdentityColumns ifTrue: [^self].
	rows := Array new: 10.
	1 to: 10 do:
		[:i || row |
		row := DatabaseRow newForTable: table.
		row preWriteAssignSequencesUsing: session.
		row postWriteAssignSequencesUsing: session accessor.
		rows at: i put: row].
	1 to: 9 do:
		[:i |
		thisID := (rows at: i) atFieldNamed: 'ID'.
		nextID := (rows at: i + 1) atFieldNamed: 'ID'.
		self assert: nextID = (thisID + 1)].