support
writeReservationData
	session beginUnitOfWork.
	session register: GlorpItinerary example1.
	session register: GlorpItinerary example2.
	session commitUnitOfWork.
	session writeRow: session system examplePassengerRow.
	session initializeCache