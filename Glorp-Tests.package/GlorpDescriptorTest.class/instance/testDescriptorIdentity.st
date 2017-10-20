tests
testDescriptorIdentity

	| descriptor |
	descriptor := system descriptorFor: GlorpCustomer.
	self assert: descriptor == (system descriptorFor: GlorpCustomer).