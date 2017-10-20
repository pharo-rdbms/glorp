iterating
rowsForTable: aTable do: aBlock
	^(self subMapForTable: aTable)
		keysAndValuesDo:
			[:key :value | (self isDeleted: value) ifFalse: [aBlock value: value]]