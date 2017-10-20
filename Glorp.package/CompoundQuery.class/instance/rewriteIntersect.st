sql generation
rewriteIntersect
	"Rewrite any INTERSECT operation we have into an EXISTS test for a correlated subselect. Only a CompoundQuery would have an intersect"
	
	| |
	operation == #INTERSECT ifFalse: [^self].
	queries := queries collect: [:each | each rewriteIntersect].
	^self rewriteSetOperationUsing: #exists: