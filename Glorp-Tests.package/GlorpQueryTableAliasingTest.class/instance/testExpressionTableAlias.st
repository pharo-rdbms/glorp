tests
testExpressionTableAlias
	| fields |
	fields := expression translateFields: expression descriptor mappedFields.
	fields do: [:each | self assert: each table name = 't1']