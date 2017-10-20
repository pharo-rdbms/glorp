This is the metadata for an individual instance variable. It will be held in a GlorpClassModel, and used for accessing the variable when building or writing out objects.

Instance Variables:
	attributeIndex	<Integer>	What is the index in the class of the instance variable. Used if we are using instVarAt: to get values.
	classModel	<GlorpClassModel>	The class model that contains us.
	collectionType	<Class>	If we are an attribute that holds a collection, what is the class of the collection.
	keyType	<Class>	If we represent a dictionary attribute, what is the type of our key (type will be used for the type of the value).
	name	<Symbol>	The name of the attribute/instance variable.
	setSelector	<Symbol>	If we are using message access to get/set values, what is the selector to use for setting. Defaults to name, ':'.
	type	<Class>	The class containing this instance variable
	useDirectAccess	<Boolean>	If true (the default) we use instVarAt:/instVarAt:put: to access the attribute values.

