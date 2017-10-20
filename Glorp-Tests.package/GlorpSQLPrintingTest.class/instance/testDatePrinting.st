tests
testDatePrinting
	| date stream |
	date := Dialect newDateWithYears: 1997 months: 11 days: 14.
	stream := WriteStream on: String new.
	date glorpPrintSQLOn: stream.
	self assert: stream contents = '''1997-11-14'''.

	date := Dialect newDateWithYears: 2002 months: 5 days: 2.
	stream := WriteStream on: String new.
	date glorpPrintSQLOn: stream.
	self assert: stream contents = '''2002-05-02'''.