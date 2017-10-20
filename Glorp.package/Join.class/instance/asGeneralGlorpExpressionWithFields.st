converting
asGeneralGlorpExpressionWithFields
	"The normal conversion of a join is to an expression equating fields and parameters. Instead, generate one with field to field comparisons"

	| main clause |
	main := nil.
	sources with: targets
		do: 
			[:eachSource :eachTarget | 
			| srcExp targetExp |
			srcExp := self targetExpressionFor: eachSource.
			targetExp := self targetExpressionFor: eachTarget.
			clause := srcExp equals: targetExp.
			main := main == nil ifTrue: [clause] ifFalse: [main AND: clause]].
	outerJoin ifTrue: [main beOuterJoin].
	^main