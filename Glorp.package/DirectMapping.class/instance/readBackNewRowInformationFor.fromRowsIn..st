mapping
readBackNewRowInformationFor: anObject fromRowsIn: aRowMap 
	| value row |
	field isGenerated ifFalse: [^self].
	self canWrite ifFalse: [^false].
	row := aRowMap findOrAddRowForTable: self field table withKey: anObject.
	value := self convertedStValueOf: (row at: field ifAbsent: [^self]).
	attribute setValueIn: anObject to: value