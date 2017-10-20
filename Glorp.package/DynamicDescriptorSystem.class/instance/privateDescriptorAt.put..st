private
privateDescriptorAt: aClass put: aDescriptor
	"Normally you don't want to be setting tables explicitly, as it may defeat the identity management but it's here if needed"
	descriptors at: aClass put: aDescriptor