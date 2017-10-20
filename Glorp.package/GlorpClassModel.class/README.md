This holds the metadata describing a class. Since Smalltalk classes are fairly self-describing, this mostly consists of the names and types of the instance variables that we want to be persistent. If those variables are collections, we also want to know the types of the items in the collections.

Instance Variables:
	attributes	<(Collection of: GlorpAttributeModel)>	Our attributes, one for each instance variable.
	describedClass	<Class>	The class we hold metadata for.
	subclasses	<Array of: Class>	The collection of subclasses of our describedClass. Computed automatically, and used as a performance optimization for inheritance testing.
	system	<DescriptorSystem>	The system that contains us.

