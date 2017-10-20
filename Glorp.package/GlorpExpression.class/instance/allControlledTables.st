preparing
allControlledTables
	"Return all the tables that we control, directly or indirectly. Basically, if we are a mapping expression with a link table, return the link table as well as any tables of ours."
	^self tables.