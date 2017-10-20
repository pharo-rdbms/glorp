testing
mappedFields
	"Return a collection of fields that this mapping will write into any of the containing object's rows"

	^self join allSourceFields select: [:each | each isMappable and: [(each isGlorpExpression not or: [each isConstantExpression not])]].