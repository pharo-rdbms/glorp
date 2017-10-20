tests
testEqualNil

	| reservations |
	reservations := session read: GlorpReservation where: [:each |
		each passengers anySatisfy: [:eachPassenger | eachPassenger isNIL]].
	self assert: reservations size = 1.
	self assert: reservations first id = 7.