tests
testReadWithCacheHits
	| query addressRow result1 result2 |
	
	[session beginTransaction.
	addressRow := session system exampleAddressRow.
	session writeRow: addressRow.
	query := Query readOneOf: GlorpAddress
				where: [:address | address id = 123].
	result1 := query executeIn: session.
	result2 := query executeIn: session.
	self assert: result1 == result2] 
			ensure: [session rollbackTransaction]