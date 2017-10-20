tests
testApplicableMappingForWriteNewProtocol

	| passenger |
	self setUpNew.
	passenger := GlorpPassenger new.
	passenger id: 1.
	self assert: (newMapping applicableMappingForObject: passenger) == mapping1.
	passenger id: 6.
	self assert: (newMapping applicableMappingForObject: passenger) == mapping2.
	passenger id: 5.
	self assert: (newMapping applicableMappingForObject: passenger) == mapping3.