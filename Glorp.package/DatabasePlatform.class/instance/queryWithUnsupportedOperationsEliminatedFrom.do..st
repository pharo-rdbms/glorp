database-specific
queryWithUnsupportedOperationsEliminatedFrom: aQuery do: aBlock
	"If aQuery has operations that we don't support, rewrite it to do them in terms of lower level operations. In particular, rewrite INTERSECT/EXCEPT operations into EXISTS clauses in a single query. Pass the new query to aBlock."
	^self.