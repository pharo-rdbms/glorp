database-specific
queryWithUnsupportedOperationsEliminatedFrom: aQuery do: aBlock
	"SQLite3 does not allow LIMIT{OFFSET} in subqueries.  As far as is known at time of writing (2011jun07), Glorp will only generate such queries in the case of a readOneOf: on a superclass which is mapped by horizontal inheritance to its subclasses' tables:  if shouldUseSingleQuery is true, it will present a series of UNION ALLed subselects on each subclass table where only one is expected to match.

To handle this case, we make the assumption that whenever all the subqueries' limits and offsets match those of the compound query, they are an artefact of the compound query's values being copied to the subqueries and really apply to the compound.  We therefore nil them for all but the last subselect.  This trick causes SQLite to interpret the resulting single LIMIT{OFFSET} at the end of the SQL string as applying to the whole UNIONed compound statement.

In the general case, there is no algorithmic way to convert subselect limits and offsets into a single limit and offset on the whole statement, and so we cannot handle the statement.  We assume no such statements will occur.  If they do, we let them go on to their inevitable failure, so it will be visible."

	| subQueries |
	subQueries := aQuery queries.
	(subQueries allSatisfy: [:each | each limit = aQuery limit and: [each offset = aQuery offset]])
"		ifFalse: [	just carry on and let it fail - don't hide the problem	]"
		ifTrue:
			[1 to: subQueries size - 1 do:
				[:index | (subQueries at: index) limit: nil; offset: nil]].