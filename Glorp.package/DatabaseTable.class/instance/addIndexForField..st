indexes
addIndexForField: aField
	^indexes add: (DatabaseIndex forField: aField).