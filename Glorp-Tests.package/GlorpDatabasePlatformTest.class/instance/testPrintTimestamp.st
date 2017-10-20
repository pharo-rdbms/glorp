tests
testPrintTimestamp

	| strings |
	strings := #( '2005-01-01 21:29:28.337'  '2005-01-01 01:02:00.037'  '2005-01-01 21:29:28.002'  '2005-01-01 21:29:28.001').
	strings do: [:each |
		self helpTestPrintTimestamp: each].