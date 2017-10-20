begin/commit/abort
createRowMapFor: objects
	| localRowMap |
	localRowMap := RowMap new: objects size.
	objects do: [:each | session createRowsFor: each in: localRowMap].
	^localRowMap