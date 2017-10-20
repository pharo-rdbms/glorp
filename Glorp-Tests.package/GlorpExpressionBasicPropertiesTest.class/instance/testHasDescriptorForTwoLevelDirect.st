tests
testHasDescriptorForTwoLevelDirect

	| exp |
	exp := [:a | a address street] asGlorpExpressionOn: base.
	self deny: exp hasDescriptor.
	self assert: exp base hasDescriptor.