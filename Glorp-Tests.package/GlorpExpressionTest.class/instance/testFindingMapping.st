tests
testFindingMapping
	| base baseDescriptor |
	baseDescriptor := system descriptorFor: GlorpBankTransaction.
	base := BaseExpression new descriptor: baseDescriptor.
	self assert: (base get: #serviceCharge) mapping == (baseDescriptor mappingForAttributeNamed: #serviceCharge).
	self assert: (base get: #serviceCharge) sourceDescriptor == (system descriptorFor: GlorpBankTransaction).
	self assert: (base get: #serviceCharge) descriptor == (system descriptorFor: GlorpServiceCharge)