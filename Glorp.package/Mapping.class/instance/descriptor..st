accessing
descriptor: aDescriptor
	descriptor := aDescriptor.
	attribute isNil ifFalse: [self copyAttributeAttributes]