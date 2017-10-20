accessing
bindings
	"We're not actually sure if we're part of a query with a where clause, or being used in a more ad hoc way. So if we have a query, use either our pre-set parameters, or the query's bindings, whichever produces more. In a tie, pick the query's bindings."
	| queryBindings |
	query isNil ifTrue: [^parameters].
	queryBindings := super bindings.
	^queryBindings size >= parameters size 
		ifTrue: [queryBindings]
		ifFalse: [parameters].