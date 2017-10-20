examples
examplePassengerRow2
	| passengerTable row |
	passengerTable := self tableNamed: 'PASSENGER'.
	row := DatabaseRow newForTable: passengerTable.
	row at: (passengerTable fieldNamed: 'ID') put: 2.
	row at: (passengerTable fieldNamed: 'NAME') put: 'Another Passenger'.
	^row.