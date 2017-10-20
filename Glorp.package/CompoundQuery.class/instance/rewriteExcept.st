sql generation
rewriteExcept
	"Rewrite any EXCEPT operation we have into a NOT EXISTS test with a correlated subselect. Only a CompoundQuery would have an EXCEPT"
	
	| |
	operation == #EXCEPT ifFalse: [^self].
	queries := queries collect: [:each | each rewriteExcept].
	^self rewriteSetOperationUsing: #notExists: