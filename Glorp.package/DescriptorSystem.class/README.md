This holds onto the Glorp metadata. Each session will have a DescriptorSystem associated with it, which describes the tables, descriptors, and class models that are to be made persistent.

Subclasses must implement the following messages:
	accessing
		allTableNames
		constructAllClasses

Instance Variables:
	allClasses	<Collection of: Behavior>	The classes we have metadata for.
	cachePolicy	<CachePolicy>	The default cache policy to use. Descriptors can override this.
	classModels	<Dictionary from: Behavior to: GlorpClassModel>	Our class models, indexed by class.
	descriptors	<Dictionary from: Behavior to: Descriptor>	Our descriptors, indexed by class.
	platform	<DatabasePlatform>	The platform for which we will be used. This is required because the table definitions will refer to the platform in order to get the appropriate types for fields.
	sequences	<Dictionary from: String to: DatabaseSequence>	The sequences that we have available, indexed by name asUppercase.
	session	<GlorpSession>	The session we provide metadata to.
	tables	<Dictionary from: String to: DatabaseTable>	Our database tables, indexed by name asUppercase.
	typeResolvers	<Dictionary from: Behavior to: TypeResolver>	The type resolvers that we will use for inheritance, indexed by class.
	useDirectAccessForMapping	<Boolean>	By default, should we use direct instance variable access (instVarAt:) or send get/set messages. Individual attributes can override this.
	useJoinsForAnySatisfy	<Boolean>	By default, should we use joins for anySatisfy and similar queries, or should we use EXISTS subselects.

