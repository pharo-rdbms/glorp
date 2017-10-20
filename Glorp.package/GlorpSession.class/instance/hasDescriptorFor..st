api
hasDescriptorFor: aClass
	"This returns false only if my DescriptorSystem has neither the requested descriptor nor the requesting class.  (If the parameter is a class that my DescriptorSystem includes, but its descriptor doesn't exist yet, an initial descriptor for it will be created and true returned.)"

	^system hasDescriptorFor: aClass