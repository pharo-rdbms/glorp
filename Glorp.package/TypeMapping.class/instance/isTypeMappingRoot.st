testing
isTypeMappingRoot
	| superClassDescriptor |
	superClassDescriptor := self descriptorForSuperclass.
	^superClassDescriptor isNil or: [ superClassDescriptor typeMapping canBeTypeMappingParent not ]