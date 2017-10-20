mapping
associationDescriptor
	associationDescriptor isNil ifTrue: [
		associationDescriptor := Descriptor new.
		associationDescriptor system: self system.
		associationDescriptor classModel: self associationClassModel].
	^associationDescriptor.