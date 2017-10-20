This is a not-especially well-named superclass for expressions that end up mapping to rows in the database, more or less. That is, it's more or less a superclass for things that have the capacity to alias tables, and to have mapping expressions derived from them. Since, depending on your point of view, everything is an object, the name isn't very descriptive. Or if some things aren't considered objects, TableExpression is a good candidate. But we have the common functionality for managing tables, and for keeping a dictionary of our sub-mapping expressions.

Subclasses must implement the following messages:
	accessing
		system
		table
	fields
		controlsTables

Instance Variables:
	fieldAliases	<Dictionary from: DatabaseField to: DatabaseField>	For each field, the corresponding aliased field for our query. So, e.g. PERSON.NAME will map to t1.NAME. These aren't strings, though, these are fields derived from the aliased table.
	mappingExpressions	<Dictionary from: Symbol to: ( MappingExpression | TableExpression) >	Each attribute that's derived from us will be maintained in this dictionary. This is very important, because Glorp relies critically on these expressions being identical. So "object field == object field".
	requiresDistinct	<Boolean>	Do the fields that we will cause to be added to the SELECT portion of the query need a DISTINCT wrapped around them?
	tableAliases	<Dictionary from: DatabaseTable to: DatabaseTable>	While the query is being prepared, tables will be assigned aliases. This keeps track of the aliases for the tables that we control. As with fieldAliases, note that this stores table copies with their names altered, not strings.

