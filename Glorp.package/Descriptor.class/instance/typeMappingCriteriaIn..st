type mapping
typeMappingCriteriaIn: base
	| r l |
	r := ConstantExpression for: self typeMapping keys.
	l := FieldExpression forField: self typeMapping field basedOn: base.
	^l in: r