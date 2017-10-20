api
descriptorFor: aClassOrObject 
	| theClass newDescriptor |
	aClassOrObject == Proxy ifTrue: [self error: 'Cannot find descriptor for the class Proxy. Pass in the instance'].
	theClass := aClassOrObject glorpCanHaveDescriptorDirectly 
				ifTrue: [aClassOrObject]
				ifFalse: [aClassOrObject isGlorpProxy 
							ifTrue: [aClassOrObject getValue class]
							ifFalse: [aClassOrObject class]].
	^descriptors
		at: theClass
		ifAbsent: [
			(self allClasses includes: theClass) ifTrue: [
				newDescriptor := self newDescriptorFor: theClass.
				descriptors at: theClass put: newDescriptor.
				self initializeDescriptor: newDescriptor.
				newDescriptor.
			]]