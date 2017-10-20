building objects
returnValueIn: aCursoredStream
	| builder |
	builder := aCursoredStream privateGetBuilders
		detect:
			[:each | 
			each instance notNil
				and: [each expression ~~ aCursoredStream command query baseExpression]]
		ifNone:
			[self error: 'Internal error in computing horizontal inheritance query.'].
	^builder instance