SQL
printNullCastOn: aStream
	"Some platforms, eg., DB2, need to cast NULL for collections, as in
	SELECT ... WHERE ... IN (CAST(NULL AS type))."
	
	| expr |
	expr := FunctionExpression
		for: #cast:
		withArguments: (Array with: (ConstantExpression for: self))
		basedOn: (ConstantExpression for: nil).
	expr printSelectSQLOn: aStream withParameters: #()