This represents the null expression, but more polymorphically than just sticking nil in the where clause. We also use this as a short-circuiting mechanism if we're given a where clause that is either just literal true or literal false. So if you end up creating a query with a literal false, we will never go to the database, we'll just return an empty collection as the result. This is more useful than you might think.

Instance Variables:
	base	<GlorpExpression>	Our base expression, which we'll use in case someone ANDs or ORs something onto us.
	value	<Boolean| nil > If we are true or false, then this result may end up being short-circuited. If it's nil, then we're just an empty where clause.

