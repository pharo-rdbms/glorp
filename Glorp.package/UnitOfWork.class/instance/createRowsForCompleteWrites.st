begin/commit/abort
createRowsForCompleteWrites
	"reference implementation. not called from anywhere"

	self registeredObjectsDo: [:eachObject | session createRowsFor: eachObject in: rowMap].
	deletedObjects do: [:eachObject | session createDeleteRowsFor: eachObject in: rowMap].