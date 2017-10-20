tests
testApplicableMappingForWriteOldProtocol

	| passenger |
	passenger := GlorpPassenger new.
	passenger id: 1.
	self assert: (mapping applicableMappingForObject: passenger) == mapping1.
	passenger id: 6.
	self assert: (mapping applicableMappingForObject: passenger) == mapping2.
	passenger id: 5.
	self assert: (mapping applicableMappingForObject: passenger) == mapping3.