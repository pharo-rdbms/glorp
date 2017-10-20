For each persistent class, there is a descriptor. This is what tells GLORP how to read and write objects of this class. The descriptor is not actually a very complicated object, because most of the information is in the mappings described below. But the descriptor does keep hold of a few per-class pieces of information, notably

Instance Variables:
	cachePolicy	<CachePolicy>	The cache policy to use. If left blank, default to what the system specifies.
	describedClass	<Class>	The persistent class that we map.
	mappedFields	<Collection of: DatabaseField>	The database fields we have mappings for (cached computed value)
	mappings	<(Collection of: Mapping)>	Our mappings.
	mapsPrimaryKeys	<Object>	Do we map the primary keys (cached computed value)
	multipleTableCriteria	<(Collection of: Join)>	description of multipleTableCriteria
	system	<DescriptorSystem>	The descriptor system that we belong to.
	tables	<(SequenceableCollection of: (DatabaseTable))>	The tables that we map
	typeResolver	<TypeResolver>	description of typeResolver

