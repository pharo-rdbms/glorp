converting
asGeneralGlorpExpression
	"Convert this to a 'normal' expression representing the same information"

	| main clause |
	main := EmptyExpression new base: base.
	sources with: targets
		do: 
			[:eachSource :eachTarget | 
			| srcExp targetExp |
			srcExp := self sourceExpressionFor: eachSource.
			targetExp := self targetExpressionFor: eachTarget.
			"Reversing the order is important because the source is the parameter, and sql won't accept '27 = FOO' "
			clause := targetExp equals: srcExp.
			main := main AND: clause].
	outerJoin ifTrue: [main beOuterJoin].
	^main