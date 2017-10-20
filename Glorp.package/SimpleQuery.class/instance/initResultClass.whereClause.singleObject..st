initialize-release
initResultClass: aClass whereClause: anExpression singleObject: aBoolean 
	super 
		initResultClass: aClass
		whereClause: anExpression
		singleObject: aBoolean.
	prepared := false.
	fields := OrderedCollection new.
	joins := OrderedCollection new