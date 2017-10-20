accessing
addAttribute: anAttributeDescription
	attributes add: anAttributeDescription.
	anAttributeDescription classModel: self.
	^anAttributeDescription