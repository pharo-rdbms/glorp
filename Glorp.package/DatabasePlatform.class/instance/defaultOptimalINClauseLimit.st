constants
defaultOptimalINClauseLimit
	"Databases have limits on the number if values allowed in an IN clause. 
	However, if you research their user forums, you'll find that there is quite a difference between the
	vendor's hard upper limit and the discovered opmimal limit. 
	Sometimes the 'real' limit is further degraded because of the total size in characters of the final SQL statement.
	This value represents a common realistic default.
	Subclasses may override this for better values for their platform."

	^500