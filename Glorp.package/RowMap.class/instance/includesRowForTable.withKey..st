lookup
includesRowForTable: aTable withKey: aKey

	| row |
	row := (self subMapForTable: aTable ifAbsent: [^false]) at: aKey ifAbsent: [^false].
	^(self isDeleted: row) not