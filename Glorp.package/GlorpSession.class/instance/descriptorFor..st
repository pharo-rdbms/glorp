api
descriptorFor: aClassOrInstance
	"If the parameter is a class that my DescriptorSystem includes, but its descriptor doesn't exist yet, an initial descriptor for it will be created.  If my DescriptorSystem has neither descriptor nor class, I return nil."

	^system descriptorFor: aClassOrInstance