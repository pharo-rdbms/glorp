indexes
addIndexForFields: aFieldCollection
	^indexes add: (DatabaseIndex forFields: aFieldCollection).