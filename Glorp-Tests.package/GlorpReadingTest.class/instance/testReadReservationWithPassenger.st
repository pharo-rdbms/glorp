tests
testReadReservationWithPassenger
	
	| reservation passenger reservations |
	[session beginTransaction.
	self writeReservationData.
	session beginUnitOfWork.
	"This doesn't validate so well. We want to make sure that the passenger table read uses a join and gets back only the one row, but it's hard to test that. Putting in an error check in the query for readOne... that returns multiple would work, but is kind of intrusive"
	reservations := session read: GlorpReservation where: [:each | each id = 2].
	self assert: reservations size = 1.
	reservation := reservations first.
	passenger := reservation passenger.
	passenger id.
	] 
			ensure: [session rollbackTransaction]