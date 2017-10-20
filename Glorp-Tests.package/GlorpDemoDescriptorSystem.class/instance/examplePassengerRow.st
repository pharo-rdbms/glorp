examples
examplePassengerRow
	| passengerTable row |
	passengerTable := self tableNamed: 'PASSENGER'.
	row := DatabaseRow newForTable: passengerTable.
	row at: (passengerTable fieldNamed: 'ID') put: 1.
	row at: (passengerTable fieldNamed: 'NAME') put: 'Some Passenger'.
	^row.