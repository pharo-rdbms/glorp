api/queries
delete: aClass where: aBlock
	"Delete all instances in the database satisfying the query block."
	
	"DELETE THEM FROM THE CACHE AS WELL, OR ELSE HAVE VERY LARGE WARNING THAT YOU'RE NOT GOING TO"
	| q |
	q := Query readOneOf: aClass where: aBlock.
	^self deleteAllSatisfying: q.