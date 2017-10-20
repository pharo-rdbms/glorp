converting
, aJoin
	| newJoin |
	aJoin isNil ifTrue: [^self].
	aJoin == self ifTrue: [^self].
	newJoin := (self class fromAll: (sources, aJoin allSourceFields) toAll: (targets, aJoin targetKeys)) removeDuplicates.
	"If either one of the contributors is an outer join, make the result be an outer join"
	newJoin outerJoin: (self outerJoin | aJoin outerJoin).
	^newJoin