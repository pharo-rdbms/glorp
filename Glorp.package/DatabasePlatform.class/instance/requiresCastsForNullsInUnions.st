testing
requiresCastsForNullsInUnions
	"If we have explicit nulls in a query which is unioned, do we need to cast them to the appropriate type in order to keep the database happy."
	^false.