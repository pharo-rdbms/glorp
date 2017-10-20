counting
numberOfEntriesForTable: aTable
	self compress.
	^(self subMapForTable: aTable) size