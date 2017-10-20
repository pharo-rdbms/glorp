tests-in
testInFromSubselect
	| query result |
	[session beginTransaction.
	self writeReservationData.
	query := Query read: GlorpItinerary where: [:each | each reservation passengers 
		anySatisfyExists: [:eachPassenger | eachPassenger airline id in: #(73 74)]].
	result := session execute: query.
	self assert: (result allSatisfy: [:each | each reservation passengers anySatisfy: [:eachPassenger | #(73 74) includes: eachPassenger airline id]]).
	self assert: result size = 2] ensure: [session rollbackTransaction].