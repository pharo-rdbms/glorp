mapping
mapFromObject: anObject intoRowsIn: aRowMap

	| row |
	self canWrite ifFalse: [^self].
	row := aRowMap findOrAddRowForTable: self field table withKey: anObject.
	row at: field put: key