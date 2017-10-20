lookup
deleteRowForTable: aTable withKey: aKey ifAbsent: aBlock
	"Don't actually delete, the fixup of the hash tables is too expensive. Mark invisible instead, overloading the status variable that we know we're not using until later"

	| row |
	row := (self subMapForTable: aTable) at: aKey ifAbsent: aBlock.
	row isNil ifFalse: [self privateDeleteRow: row]