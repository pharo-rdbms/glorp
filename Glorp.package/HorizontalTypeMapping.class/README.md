HorizontalTypeMapping assumes that all objects are stored in different tables. Only leaf classes in the inheritance hierarchy can be mapped. The descriptors for the classes themselves have the necessary information, our only job is to be involved in building up the query. Queries can be done either by splitting up into a series of separate queries, or as one horribly complex query with union all clauses.

Instance Variables:
	isAbstract	<Boolean>	Is this an abstract superclass.
	mappedClass	<Class>	The class that we are mapping.

