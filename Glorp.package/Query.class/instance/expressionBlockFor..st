ordering
expressionBlockFor: anOrderingCriteria
	"Allow us to use symbols interchangeably with simple blocks for ordering, so 
	#firstName is equivalent to [:each | each firstName]. Also, allow chains of symbols, so #(owner firstName)"

	anOrderingCriteria isGlorpExpression ifTrue: [^anOrderingCriteria].
	anOrderingCriteria glorpIsBlock ifTrue: [^anOrderingCriteria].

	anOrderingCriteria isSymbol 
		ifTrue: [^[:each | each perform: anOrderingCriteria]].
	
	"otherwise, we assume it's a collection of symbols, the only other valid case"
	anOrderingCriteria do: [:each | each isSymbol ifFalse: [self error: 'invalid ordering criteria']].
	^[:each | anOrderingCriteria inject: each into: [:sum :eachExpression |
		sum perform: eachExpression]]