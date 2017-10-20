configuration
includeAllClassesWithDescriptorMethods
	"If this is true, the descriptor system will automatically include all classes that define the #glorpSetupDescriptor:forSystem: method on the class side. If false, it will only include classes which have descriptor methods defined in this class, or those explicitly added in the #constructAllClasses method."
	^false