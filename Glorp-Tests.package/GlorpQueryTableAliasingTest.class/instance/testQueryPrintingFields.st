tests
testQueryPrintingFields
	| stream |
	query 
		initResultClass: GlorpCustomer
		whereClause: expression
		singleObject: true.
	query limit: nil.
	query setupTracing.
	query computeFields.
	stream := String new writeStream.
	query printSelectFieldsOn: stream.
	self assert: stream contents = 't1.ID, t1.NAME'