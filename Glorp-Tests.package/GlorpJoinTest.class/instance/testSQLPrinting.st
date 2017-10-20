tests
testSQLPrinting
	| stream params |
	stream := WriteStream on: (String new: 100).
	params := Dictionary new.
	params at: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'ID') put: 'abc'.
	expression printSQLOn: stream withParameters: params.
	self assert: stream contents = 'CUSTOMER_ACCT_LINK.ACCT_ID = ''abc'''