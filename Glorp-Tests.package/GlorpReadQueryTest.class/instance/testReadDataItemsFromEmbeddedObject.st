tests-data reading
testReadDataItemsFromEmbeddedObject

	| query result transRow id |
	transRow := session system exampleBankTransactionRow.
	session writeRow: transRow.
	id := transRow atFieldNamed: 'ID'.
	query := Query read: GlorpBankTransaction.
	query retrieve: [:each | each id].
	query retrieve: [:each | each serviceCharge description].
	result := query executeIn: session.
	self assert: result size = 1.
	self assert: result first = (Array with: id with: 'additional overcharge').