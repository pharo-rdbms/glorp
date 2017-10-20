tests
testNegateMappingRead
	| amountField inputRow builder |
	descriptor := system descriptorFor: GlorpMoney.
	table := system tableNamed: 'MONEY_IMAGINARY_TABLE'.
	amountField := table fieldNamed: 'AMOUNT'.
	mapping := self moneyNegatingMappingTo: amountField in: descriptor.
	descriptor addMapping: mapping.
	money := GlorpMoney basicNew.
	inputRow := #('US' 1).
	builder := ElementBuilder new.
	builder row: inputRow.
	mapping mapObject: money inElementBuilder: builder.
	self assert: money amount = -1.