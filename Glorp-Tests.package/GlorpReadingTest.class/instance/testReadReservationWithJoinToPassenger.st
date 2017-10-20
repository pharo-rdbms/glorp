tests
testReadReservationWithJoinToPassenger
	| reservations |
	
	[session beginTransaction.
	self writeReservationData.
	session beginUnitOfWork.
	reservations := session read: GlorpReservation
				where: [:each | each passenger id = 3].
	self assert: reservations size = 1.
	self assert: reservations first passengers size = 1.] 
			ensure: [session rollbackTransaction]