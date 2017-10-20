tests
testBuildBankTransactionAndDependentsFromRow
	| transactionDescriptor object row moneyDescriptor money1 table translations session builder |
	session := GlorpMockSession new.
	session system: system.
	transactionDescriptor := system descriptorFor: GlorpBankTransaction.
	object := GlorpBankTransaction new.
	row := #(99 nil 'CDN' 98 'service charge' 'USD' 97).
	builder := ObjectBuilder new.
	builder row: row.
	transactionDescriptor populateObject: object inBuilder: builder.
	self assert: object id = 99.
	moneyDescriptor := system descriptorFor: GlorpMoney.
	money1 := GlorpMoney new.
	table := system tableNamed: 'MONEY_IMAGINARY_TABLE'.
	translations := IdentityDictionary new.
	translations at: (table fieldNamed: 'CURRENCY') put: 3.
	translations at: (table fieldNamed: 'AMOUNT') put: 4.
	builder := ElementBuilder new fieldTranslations: translations; row: row.
	moneyDescriptor
		populateObject: money1
		inBuilder: builder.
	self assert: money1 amount = 98.
	self assert: money1 currency = #CDN.