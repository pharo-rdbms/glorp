api
deleteRowForTable: aTable withKey: aKey ifAbsent: aBlock
	^super deleteRowForTable: aTable withKey: (self mementoFor: aKey) ifAbsent: aBlock