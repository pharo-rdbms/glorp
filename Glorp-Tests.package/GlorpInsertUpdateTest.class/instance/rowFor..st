support
rowFor: anObject

	| rowMap rows |
	rowMap := RowMap new.
	session createRowsFor: anObject in: rowMap.
	rows := rowMap rowsForKey: anObject.
	self assert: rows size = 1.
	^rows first.