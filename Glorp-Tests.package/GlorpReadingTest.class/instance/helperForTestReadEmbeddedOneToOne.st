support
helperForTestReadEmbeddedOneToOne
	| transRow query result |
	
	[session beginTransaction.
	transRow := session system exampleBankTransactionRow.
	session writeRow: transRow.
	query := Query readOneOf: GlorpBankTransaction
				where: [:each | each id = each id].
	result := query executeIn: session] 
			ensure: [session rollbackTransaction].
	self assert: result serviceCharge notNil.
	self assert: result serviceCharge description = 'additional overcharge'.
	self assert: result amount currency = #CDN.
	self assert: result amount amount = 7.
	self assert: result serviceCharge amount currency = #USD.
	self assert: result serviceCharge amount amount = 2.
	^result.