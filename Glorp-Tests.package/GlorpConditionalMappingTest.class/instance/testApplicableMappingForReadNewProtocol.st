tests
testApplicableMappingForReadNewProtocol

	| builder |
	self setUpNew.
	builder := ElementBuilder for: ([:x | x] asGlorpExpressionForDescriptor: descriptor) in: SimpleQuery new.
	self assert: (newMapping applicableMappingForRow: #(1 foo nil nil) in: builder) == mapping1.
	self assert: (newMapping applicableMappingForRow: #(6 foo nil nil) in: builder) == mapping2.
	self assert: (newMapping applicableMappingForRow: #(5 foo nil nil) in: builder) == mapping3.