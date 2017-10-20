sql generation
rewriteIntersect
	"Rewrite any INTERSECT operation we have into an EXISTS tests. Only a CompoundQuery would have such an operation"