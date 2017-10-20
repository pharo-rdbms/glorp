initialization
constructAllClasses
	"Subclasses can override this method to add classes. But by default we also look for all descriptor methods in our system, and add them to the class list, so if the methods are written there, then we don't need to do anything further. If the descriptor methods are defined on the classes themselves, then we'll still have to construct the class list manually."

	self constructClassesFromDescriptorMethods.
	^allClasses.