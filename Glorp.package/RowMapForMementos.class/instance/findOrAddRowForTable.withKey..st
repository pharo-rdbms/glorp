api
findOrAddRowForTable: aTable withKey: aKey 
	^super findOrAddRowForTable: aTable withKey: (self mementoFor: aKey)