mapping
addTypeMappingCriteriaTo: collection in: base
	| singleRightValue r l |
	singleRightValue := self keys size = 1.
	r := ConstantExpression for: (singleRightValue
											ifTrue: [self keys asArray first]
											ifFalse: [self keys]).
	l := FieldExpression forField: self field basedOn: base.
	collection add: (singleRightValue ifTrue: [l equals: r] ifFalse: [l in: r])