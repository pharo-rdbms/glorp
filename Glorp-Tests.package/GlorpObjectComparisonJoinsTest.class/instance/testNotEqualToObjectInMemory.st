tests
testNotEqualToObjectInMemory
	| reservations |
	reservations := session read: GlorpReservation where: [:each |
		each passengers anySatisfy: [:eachPassenger | eachPassenger ~= (GlorpPassenger new id: 7)]].
	self assert: reservations size = 1.
	self assert: reservations first id = 2.
	self assert: reservations first passenger id = 3.