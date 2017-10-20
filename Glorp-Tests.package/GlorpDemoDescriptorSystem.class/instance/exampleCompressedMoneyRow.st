examples
exampleCompressedMoneyRow
	| table row |
	table := self  tableNamed: 'COMPRESSED_MONEY_TABLE'.
	row := DatabaseRow newForTable: table.
	row at: (table fieldNamed: 'ID') put: 123.
	row at: (table fieldNamed: 'AMOUNT') put: 12.
	row at: (table fieldNamed: 'CURRENCY_NAME') put: 'CDN'.
	^row