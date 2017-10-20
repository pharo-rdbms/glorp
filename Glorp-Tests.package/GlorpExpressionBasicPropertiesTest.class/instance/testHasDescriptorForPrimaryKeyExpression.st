tests
testHasDescriptorForPrimaryKeyExpression

	| exp |
	exp := Join new.
	self deny: exp hasDescriptor.