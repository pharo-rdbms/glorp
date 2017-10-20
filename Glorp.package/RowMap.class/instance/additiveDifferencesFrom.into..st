set operations
additiveDifferencesFrom: aRowMap into: differencesMap
	"Add everything which is in us, but not in aRowMap into differencesMap"
	| newRow |
	self objectsAndRowsDo: [:object :row |
		| correspondingRow |
		correspondingRow := aRowMap
			rowForTable: row table
			withKey: object
			ifAbsent: [DatabaseRow new].
		(row equals: correspondingRow)
			ifFalse:
				[newRow := differencesMap
					addRow: (row withAllFieldsIn: correspondingRow)
					forTable: row table
					withKey: object.
				newRow forDeletion: row forDeletion]]