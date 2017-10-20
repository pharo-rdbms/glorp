mapping
mapFromObject: anObject toTarget: target puttingRowsIn: aRowMap

	| dbValue value row |
	self canWrite ifFalse: [^self].
	value := self getValueFrom: anObject.
	value := self session realObjectFor: value ifNone: [^self].
	dbValue := self convertedDbValueOf: value.
	row := aRowMap findOrAddRowForTable: self field table withKey: target.
	row at: field put: dbValue