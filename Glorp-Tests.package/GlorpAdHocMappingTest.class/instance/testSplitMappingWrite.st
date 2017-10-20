tests
testSplitMappingWrite
	| outputRow |
	money := GlorpCompressedMoney currency: 'DM' amount: 99.
	mapping := (system descriptorFor: GlorpCompressedMoney) 
				mappingForAttributeNamed: #array.
	rowMap := RowMap new.
	mapping mapFromObject: money intoRowsIn: rowMap.
	table := mapping descriptor primaryTable.
	outputRow := rowMap rowForTable: table withKey: money.
	self assert: (outputRow at: (table fieldNamed: 'AMOUNT')) = 99.
	self assert: (outputRow at: (table fieldNamed: 'CURRENCY_NAME')) = 'DM'