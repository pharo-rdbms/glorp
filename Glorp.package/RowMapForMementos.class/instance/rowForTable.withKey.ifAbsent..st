api
rowForTable: aTable withKey: aKey ifAbsent: aBlock
	^super
		rowForTable: aTable
		withKey: (self mementoFor: aKey)
		ifAbsent: aBlock