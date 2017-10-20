tests
testHasDescriptorForDirect

	| exp |
	exp := [:a | a id ] asGlorpExpressionOn: base.
	self deny: exp hasDescriptor.