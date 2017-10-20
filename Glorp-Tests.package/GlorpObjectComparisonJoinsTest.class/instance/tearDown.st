support
tearDown
	
	session rollbackTransaction.
	itinerary1 := nil.
	itinerary2 := nil.
	super tearDown.