private
initializeDescriptor: aDescriptor 
	| selector |
	selector := ('descriptorFor' , aDescriptor describedClass name , ':') asSymbol.
	(self respondsTo: selector) 
		ifTrue: [self perform: selector with: aDescriptor]
		ifFalse: [
			(aDescriptor describedClass respondsTo: #glorpSetupDescriptor:forSystem:)
				ifTrue: [aDescriptor describedClass
								glorpSetupDescriptor: aDescriptor
								forSystem: self]
				ifFalse: [self noDescriptorInitializerFound: aDescriptor]]