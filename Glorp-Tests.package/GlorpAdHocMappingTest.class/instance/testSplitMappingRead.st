tests
testSplitMappingRead
	| inputRow builder |
	money := GlorpCompressedMoney basicNew.
	mapping := (system descriptorFor: GlorpCompressedMoney)
		mappingForAttributeNamed: #array.
	inputRow := #(432 'US' 1).
	builder := ElementBuilder new.
	builder row: inputRow.
	mapping mapObject: money inElementBuilder: builder.
	self assert: money amount = 1.
	self assert: money currency = 'US'.