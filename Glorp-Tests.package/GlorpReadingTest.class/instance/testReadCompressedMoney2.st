tests
testReadCompressedMoney2
	| object query results rowToWrite |
	
	[session beginTransaction.
	rowToWrite := session system exampleCompressedMoneyRow.
	session writeRow: rowToWrite.
	query := Query read: GlorpCompressedMoney
				where: [:money | money = (GlorpCompressedMoney new id: 123; currency: 'CDN'; amount: 12)].
	results := query executeIn: session] 
			ensure: [session rollbackTransaction].
	self assert: results size = 1.
	object := results first.
	self assert: object class = GlorpCompressedMoney.
	self assert: object amount = 12.
	self assert: object currency = 'CDN'.