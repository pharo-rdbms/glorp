tests
testDeleteMultipleTable
	| passengerRow1 passengerRow2 passenger rows frequentFlyerRow1 frequentFlyerRow2 |
	
	[
	session beginTransaction.
	passengerRow1 := session system examplePassengerRow.
	session writeRow: passengerRow1.
	frequentFlyerRow1 := session system exampleFrequentFlyerRow.
	session writeRow: frequentFlyerRow1.
	passengerRow2 := session system examplePassengerRow2.
	session writeRow: passengerRow2.
	frequentFlyerRow2 := session system exampleFrequentFlyerRow2.
	session writeRow: frequentFlyerRow2.
	passenger := session readOneOf: GlorpPassenger.
	session delete: passenger.
	rows := session accessor executeSQLString: 'SELECT * FROM FREQUENT_FLYER'.
	self assert: rows size = 1.
	rows := session accessor executeSQLString: 'SELECT * FROM PASSENGER'.
	self assert: rows size = 1.
	] 
			ensure: [session rollbackTransaction]