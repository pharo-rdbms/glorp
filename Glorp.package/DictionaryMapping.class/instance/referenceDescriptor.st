accessing
referenceDescriptor
	| ref |
	ref := super referenceDescriptor.
	^ref isNil 
		ifTrue: [
			"This means we haven't yet added our fake descriptor, and are in initialization, so just return the descriptor for the 'real' reference class"
			self system descriptorFor: self basicReferenceClass]
		ifFalse: [ref]