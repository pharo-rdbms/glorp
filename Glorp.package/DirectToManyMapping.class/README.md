This is a to-many mapping where the class in the collection is a simple type, not a compound object. This requires fiddling with the descriptors, to allow each such mapping to define a different descriptor for the target class. This should be regarded as something of a prototype. It seems to work, at least for basic operations, but it may well have problems.

Instance Variables:
	resultField	<DatabaseField>	The field in the target table in which we have our results.

