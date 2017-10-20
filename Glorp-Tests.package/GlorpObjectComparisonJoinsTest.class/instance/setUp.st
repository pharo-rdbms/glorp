support
setUp
	super setUp.
	session system useJoinsForAnySatisfy: true.
	session beginTransaction.
	itinerary1 := GlorpItinerary example1.
	itinerary2 := GlorpItinerary example2.
	itinerary2 reservation passenger: nil.
	itinerary2 reservation passengers: #().

	session transact: [
		session register: itinerary1.
		session register: itinerary2].