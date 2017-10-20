lookup
rowForTable: aTable withKey: aKey ifPresent: aBlock
	^(self subMapForTable: aTable)
		at: aKey
		ifPresent:
			[:row | (self isDeleted: row) ifTrue: [nil] ifFalse: [aBlock value: row]]