api
findOrAddRowForTable: aTable withKey: aKey
	| submap row |
	submap := self subMapForTable: aTable withKey: aKey.
	row := submap
		at: aKey
		ifAbsentPut: [DatabaseRow newForTable: aTable withOwner: aKey].
	^(self isDeleted: row)
		ifTrue:
			[| newRow |
			newRow := DatabaseRow newForTable: aTable withOwner: aKey.
			submap at: aKey put: newRow.
			newRow]
		ifFalse: [row]