This is the abstract superclass for all Glorp mappings. A mapping defines how one particular instance variable will be mapped into and out of the database. There is considerable variation among the subclasses.

Subclasses must implement the following messages:
	accessing
		allTables
	mapping
		mapFromObject:intoRowsIn:
		mapObject:inElementBuilder:
		referencedIndependentObjectsFrom:
		trace:context:
	testing
		controlsTables
		isRelationship
		isStoredInSameTable
		mappedFields

Instance Variables:
	attribute	<GlorpAttributeModel>	The description of the instance variable we map.
	canRead	<Boolean>	Is this mapping allowed to read.
	canWrite	<Boolean>	Is this mapping allowed to write.
	debugRead	<Boolean>	For debugging purposes. If true, we will halt when this mapping is about to read..
	debugWrite	<Boolean>	For debugging purposes. If true, we will halt when this mapping is about to write.
	descriptor	<Descriptor>	The descriptor that contains this mapping.

