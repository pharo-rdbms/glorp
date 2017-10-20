tests
testApplicableMappingForReadOldProtocol

	| builder |
	builder := ElementBuilder for: ([:x | x] asGlorpExpressionForDescriptor: descriptor) in: SimpleQuery new.
	self assert: (mapping applicableMappingForRow: #(1 foo nil nil) in: builder) == mapping1.
	self assert: (mapping applicableMappingForRow: #(6 foo nil nil) in: builder) == mapping2.
	self assert: (mapping applicableMappingForRow: #(5 foo nil nil) in: builder) == mapping3.