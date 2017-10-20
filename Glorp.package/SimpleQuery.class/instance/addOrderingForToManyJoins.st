preparing
addOrderingForToManyJoins
	"If we have a join to a to-many relation, then we need for all the joined bits to be grouped together in order in the result set."

	| toManyBuilders baseBuilders |
	toManyBuilders := builders select: [:each | each canCauseDuplicateRows].
	baseBuilders := toManyBuilders collect:
		[:each |
		builders
			detect: [:eachBuilder | eachBuilder expression == each expression base]
			ifNone: [nil]].
	baseBuilders do: [:each | each isNil ifFalse: [self addAllOrderingsForBuilder: each]].
	"If a fetched expression matches that of a toMany builder, it may be ordered."
	tracing alsoFetchExpressions do:
		[:alsoFetchExp || orderFields |
		((toManyBuilders anySatisfy: [:each | alsoFetchExp = each expression]) and:
				[(orderFields := alsoFetchExp mapping orderBy) notNil]) ifTrue:
			[orderFields do:
				[:orderField || orderExp |
				orderExp := self expressionBlockFor: orderField.
				self addSingleOrderingForBuilder: (orderExp asGlorpExpressionOn: alsoFetchExp)]]].