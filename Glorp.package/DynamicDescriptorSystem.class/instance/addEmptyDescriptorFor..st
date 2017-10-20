accessing
addEmptyDescriptorFor: aClass 
	| descriptor |
	descriptor := Descriptor new.
	descriptor system: self.
	self privateDescriptorAt: aClass put: descriptor.
	descriptor classModel: (self classModelFor: aClass).
	^descriptor