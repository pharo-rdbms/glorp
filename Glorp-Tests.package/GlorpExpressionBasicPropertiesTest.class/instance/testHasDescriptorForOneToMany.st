tests
testHasDescriptorForOneToMany

	| exp |
	exp := [:a | a emailAddresses ] asGlorpExpressionOn: base.
	self assert: exp hasDescriptor.