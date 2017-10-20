api
at: aField key: anObject put: aValue
	(self findOrAddRowForTable: aField table withKey: anObject) at: aField put: aValue