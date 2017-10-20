tests
testReadPassenger
	| passengerRow1 passengerRow2 query result |
	
	[session beginTransaction.
	passengerRow1 := session system examplePassengerRow.
	session writeRow: passengerRow1.
	passengerRow2 := session system exampleFrequentFlyerRow.
	session writeRow: passengerRow2.
	query := Query readOneOf: GlorpPassenger
				where: [:passenger | passenger id = 1].
	result := query executeIn: session.
	self assert: result id = 1.
	self assert: result name = 'Some Passenger'.
	self assert: result frequentFlyerPoints = 10000] 
			ensure: [session rollbackTransaction]