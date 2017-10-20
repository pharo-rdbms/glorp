tests
testHasDescriptorForBase

	| exp |
	self assert: base hasDescriptor.
	exp := [:a | a ] asGlorpExpressionOn: base.
	self assert: exp hasDescriptor.