TypeResolvers are used to implement inheritance. Each descriptor has a type resolver, which can be asked for the types associated with that descriptor. By default we get an IdentityTypeResolver, which just gives us a single class. With inheritance we can get different types.

Subclasses must implement the following messages:
	accessing
		classesRequiringIndependentQueriesFor:
		describedConcreteClassFor:withBuilder:descriptor:
	type resolution
		typeMappingRootDescriptor

Instance Variables:
	members	<(SequenceableCollection of: (Descriptor))>	The descriptors of the classes that this resolver applies to.
	system	<DescriptorSystem>	The system in which the members live.

