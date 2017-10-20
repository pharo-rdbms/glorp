TypeMappings are used to implement inheritance. They do not map to particular instance variables, but instead define things about the way the class is read. The default type mapping is IdentityTypeMapping, which does nothing. To use inheritance, substitute either a FilteredTypeMapping or a HorizontalTypeMapping. TypeMappings become part of a TypeResolver, which keeps the information for a class and its subclasses, each of which will have a typeMapping specific to that class.

Subclasses must implement the following messages:
	testing
		isAbstract

