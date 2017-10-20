tests
testQueryPrintingTables
	| stream string |
	query 
		initResultClass: GlorpCustomer
		whereClause: expression
		singleObject: true.
	query setupTracing.
	query computeFields.
	stream := String new writeStream.
	query printTablesOn: stream.
	string := stream contents.
	self assert: string withUnixLineEndings = '<n> FROM GR_CUSTOMER t1' expandMacros withUnixLineEndings.