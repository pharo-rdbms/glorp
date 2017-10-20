initialize-release
setup
	"Do any initialization once we've got our parameters"
	| base collectionType |
	base := query baseExpression.
	collectionType := expression == base ifTrue: [query collectionType] ifFalse: [expression mapping query collectionType].
	keyBuilder := ElementBuilder for: (collectionType keyExpression asGlorpExpressionOn: expression) in: query.
	valueBuilder := ElementBuilder basicFor: (collectionType valueExpression asGlorpExpressionOn: expression) in: query