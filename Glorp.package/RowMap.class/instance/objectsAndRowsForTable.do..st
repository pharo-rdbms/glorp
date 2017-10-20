iterating
objectsAndRowsForTable: aTable do: aTwoArgumentBlock
	^(self subMapForTable: aTable)
		keysAndValuesDo:
			[:key :value | 
			(self isDeleted: value)
				ifFalse: [aTwoArgumentBlock value: key value: value]]