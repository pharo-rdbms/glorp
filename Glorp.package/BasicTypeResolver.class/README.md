This is an abstract superclass for TypeResolvers that do inheritance in some form.

Instance Variables:
	concreteMembers	<(Collection of: (Descriptor))>	Which of our members can actually be instantiated, as opposed to abstract superclasses.
	rootClass	<Behavior>	Which is the root class of the inheritance hierarchy we represent.
	rootDescriptor	<Descriptor>	The descriptor for the root class
	subclassDescriptorsBuilt	<Boolean>	Have we asked the system for the descriptors for all of the root's subclasses yet?

