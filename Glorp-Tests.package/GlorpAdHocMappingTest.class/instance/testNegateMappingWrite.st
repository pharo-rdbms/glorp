tests
testNegateMappingWrite
	| amountField outputRow |
	descriptor := system descriptorFor: GlorpMoney.
	table := system tableNamed: 'MONEY_IMAGINARY_TABLE'.
	amountField := table fieldNamed: 'AMOUNT'.
	mapping := self moneyNegatingMappingTo: amountField in: descriptor.
	descriptor table: table.
	descriptor addMapping: mapping.
	money := GlorpMoney forAmount: 3.
	rowMap := RowMap new.
	mapping mapFromObject: money intoRowsIn: rowMap.
	outputRow := rowMap rowForTable: table withKey: money.
	self assert: (outputRow at: (table fieldNamed: 'AMOUNT')) = -3