preparing
addAllOrderingsForBuilder: aBuilder
	
	| expression fieldExpressions |
	expression := aBuilder expression.
	fieldExpressions := expression descriptor primaryTable primaryKeyFields collect: [:each | expression getField: each].
	fieldExpressions do: [:each | self addSingleOrderingForBuilder: each]