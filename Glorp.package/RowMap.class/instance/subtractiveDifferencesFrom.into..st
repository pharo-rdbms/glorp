set operations
subtractiveDifferencesFrom: aRowMap into: differencesMap
	"Figure out which things are in aRowMap but not in us. These should be flagged as delete rows. Since we have no further use for aRowMap after this, we can compute this destructively by removing everything that's in us"

	self objectsAndRowsDo: [:object :row |
		aRowMap
			deleteRowForTable: row table
			withKey: object
			ifAbsent: []].
	aRowMap
		objectsAndRowsDo:
			[:object :row | 
			| adjustedObject |
			adjustedObject := (aRowMap reverseLookup: object).
			row forDeletion: true.
			differencesMap
				addRow: row
				forTable: row table
				withKey: adjustedObject]