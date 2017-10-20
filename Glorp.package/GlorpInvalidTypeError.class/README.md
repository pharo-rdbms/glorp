When mapping, if we encounter an object in a relationship that doesn't match the type we're expecting from the ClassModel/AttributeModel then we raise this exception. 

Instance Variables:
	expectedType	<GlorpClassModel>		The classModel for the type we were expecting.
	object	<Object>	The object that contained the invalid reference.

