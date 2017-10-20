private
newDescriptorFor: aClass

	| newDescriptor |
	(self allClasses includes: aClass) ifFalse: [^nil].
	newDescriptor := Descriptor new.
	newDescriptor system: self.
	newDescriptor classModel: (self classModelFor: aClass).
	^newDescriptor