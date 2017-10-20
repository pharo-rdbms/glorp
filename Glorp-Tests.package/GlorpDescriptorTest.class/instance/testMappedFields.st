tests
testMappedFields

	| descriptor |
	descriptor := system descriptorFor: GlorpBankTransaction.
	self assert: (descriptor mappedFields) = (descriptor table fields).