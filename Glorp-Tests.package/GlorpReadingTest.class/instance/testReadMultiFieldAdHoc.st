tests
testReadMultiFieldAdHoc
	| object query results rowToWrite row2 |
	
	[session beginTransaction.
	rowToWrite := session system exampleCompressedMoneyRow.
	row2 := session system exampleCompressedMoneyRow2.
	session writeRow: rowToWrite.
	session writeRow: row2.

	query := Query read: GlorpCompressedMoney
				where: [:money | money array = #('CDN' 12)].
	results := query executeIn: session] 
			ensure: [session rollbackTransaction].
	self assert: results size = 1.
	object := results first.
	self assert: object class = GlorpCompressedMoney.
	self assert: object amount = 12.
	self assert: object currency = 'CDN'.