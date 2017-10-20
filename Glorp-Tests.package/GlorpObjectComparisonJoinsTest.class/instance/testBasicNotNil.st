tests
testBasicNotNil

	| reservations |
	reservations := session read: GlorpReservation where: [:each |
		each passenger notNIL].
	self assert: reservations size = 1.
	self assert: reservations first id = 2.
	self assert: reservations first passenger id = 3.