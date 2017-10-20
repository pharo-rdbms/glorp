tests
testCompoundSQLPrinting
	| stream params|
	stream := WriteStream on: (String new: 100).
	params := Dictionary new.
	params at: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'ID') put: 1.
	params at: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'BANK_CODE') put: 3.
	compoundExpression printSQLOn: stream withParameters: params.
	self assert: stream contents = 'PERSON.NAME = 1 AND PERSON.ADDRESS_ID = 3'.