private
privateAndBasicAddDescriptorFor: anObject as: aDescriptor
	"Just add the descriptor and don't try to validate. anObject may not actually even be a class. Assume the descriptor is already properly initialized"
	descriptors at: anObject put: aDescriptor.
	aDescriptor system: self