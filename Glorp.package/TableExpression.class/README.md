This is an expression representing a table. Typically we refer to things in terms of objects which control tables, but sometimes you want to refer directly to a table that's not mapped, either in the process of building up a more OO representing (e.g. referring to a link table) or because we just want to do something more complicated that's not mapped, or incompletely mapped.

Instance Variables:
	base	<BaseExpression | MappingExpression>	The expression on which we are built.
	table	<DatabaseTable>	The table that we represent.

