tests
testSQLPrinting
	| stream params |
	stream := WriteStream on: (String new: 100).
	params := Dictionary new.
	expression printSQLOn: stream withParameters: params.
	self assert: stream contents = 'CUSTOMER_ACCT_LINK.ACCT_ID = 7'