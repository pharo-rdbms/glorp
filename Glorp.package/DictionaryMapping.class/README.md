This allows us to map a dictionary into tables. It should, I hope, support arbitrarily either mapping to single fields, or to objects, for either the key or the value. At the moment, it at least passes the tests for the value->object and value->value cases.

Instance Variables:
	keyMapping	<DatabaseMapping>	The mapping to use to read/write the key. It should be for an attribute named #key.
	valueMapping	<DatabaseMapping>	The mapping to use to read/write the value. It should be for an attribute named #value. Note that this is optional, and isn't a full blown mapping, because if we have a relationship, we will normally just use this mapping to describe it directly. If we have a direct mapping for the value, then we have this odd situation where we use the Join from this mapping, but the direct mapping to control the read/write of the variable.
	associationDescriptor	<Descriptor>	We manipulate the key/value pairs as associations in some places, and have a mock descriptor for association, specific to this mapping, which is used to get the key/value.


