initializing
initializeValueMapping
	| referenceDescriptor |
	self descriptor system privateAndBasicAddDescriptorFor: self as: self associationDescriptor.
	(self associationDescriptor classModel attributeNamed: #key) type: self attribute keyType.
	(self associationDescriptor classModel attributeNamed: #value) type: self attribute type.
	referenceDescriptor := self referenceDescriptor.
	(referenceDescriptor isNil or: [referenceDescriptor tables isEmpty]) ifTrue: [self initializeValueMappingJoin].