sql generation
rewriteExcept
	"Rewrite any EXCEPT operation we have into a NOT EXISTS tests. Only a CompoundQuery would have such an operation"