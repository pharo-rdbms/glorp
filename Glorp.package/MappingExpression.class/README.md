This represents an attribute of some other object. It's called a mapping expression because each attribute has a mapping, and when we come to prepare the query, we'll be using that mapping's information to deduce joins, and to print properly.

Instance Variables:
	base	<BaseExpression | MappingExpression>	The expression we are built on, which is to say the expression describing the object of which we are an attribute.
	mapping	<Mapping>	The mapping we correspond to in the base. So if the base was [:each | each owner city] and we are #name, then we the mapping is for the attribute #name in the descriptor for City.
	name	<Symbol>	The name of our attribute. We will use this to determine the mapping.
	outerJoin	<Boolean>	Are we to interpret the join to our parent object's table as being an outer join or not?
	phantom <Boolean> Is this a phantom mapping - one which is not defined in the descriptor explicitly, but is temporarily created to define a reverse relationship, an alsoFetch of subclasses, or some other transient usage.

