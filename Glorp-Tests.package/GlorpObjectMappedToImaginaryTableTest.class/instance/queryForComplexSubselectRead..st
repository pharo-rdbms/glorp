tests
queryForComplexSubselectRead: anInteger
	"This exercises doubly-nested subselects, which caused a problem in a user application with joining to the wrong table. The gist of the query is stores where more than anInteger different customers have made rentals"

	| q1 q2 q3 |
	q1 := Query
		read: GlorpVideoStore
		where: [:store | 
			q2 := Query
				count: GlorpVideoCustomer
				where: [:customer | 
					q3 := Query
						read: GlorpVideoRental
						where: [:rental | rental store = store].
					q3 retrieve: [:trade | trade customerName].
					customer name in: q3].
			(store getConstant: anInteger) <= q2].
	^q1.