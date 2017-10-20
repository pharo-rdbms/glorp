As yet unclassified
helpTestPrintingWhereClause: anExpression
	| command |
	query 
		initResultClass: GlorpCustomer
		whereClause: expression
		singleObject: true.
	query setupTracing.
	query computeFields.
	command := GlorpNullCommand useBinding: false session: session.
	anExpression	
		printSQLOn: command
		withParameters: Dictionary new.
	^command sqlString.