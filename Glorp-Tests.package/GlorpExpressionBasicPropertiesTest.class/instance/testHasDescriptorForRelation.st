tests
testHasDescriptorForRelation

	| exp |
	exp := [:a | a = 3] asGlorpExpressionOn: base.
	self deny: exp hasDescriptor.