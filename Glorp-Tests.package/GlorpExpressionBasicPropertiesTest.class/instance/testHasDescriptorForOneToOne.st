tests
testHasDescriptorForOneToOne

	| exp |
	exp := [:a | a address ] asGlorpExpressionOn: base.
	self assert: exp hasDescriptor.