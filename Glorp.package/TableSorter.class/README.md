This implements a topological sort for tables, based on the foreign key constraints between them.

Instance Variables:
	orderedTables	<Collection of: DatabaseTable>	The resulting tables in sorted order.
	tables	<(Collection of: (DatabaseTable))>	The input tables.
	visitedTables	<IdentitySet of: DatabaseTable>	The tables we have already visited during the sort.

