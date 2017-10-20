When querying for a dictionary, it's not enough to tell the query to return its collection in a dictionary. We need to be able to describe both the key and the value. So we would pass an instance of this as the collectionType: to a query or mapping.

Instance Variables:
	keyExpression	<GlorpExpression | Block>	The description of the key
	valueExpression	<GlorpExpression | Block>	The description of the value

