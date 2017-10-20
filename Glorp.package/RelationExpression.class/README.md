This represents a relationship between two sub-expressions, that is something like = or AND. So in object attribute = field, we're the equals node. We have exactly two children, and mostly just print ourselves in between them. However there is some other interesting logic in there about splitting up comparisons between objects into comparisons between keys, and even just printing can get fairly complicated.

Instance Variables:
	leftChild	<GlorpExpression>	The left child.
	rightChild	<GlorpExpression>	The right child.
	outerJoin	<Boolean>	Is this an outer join (only makes sense if we are an equality comparison.
	relation	<String>	The string or symbol that we print for our relationship.

