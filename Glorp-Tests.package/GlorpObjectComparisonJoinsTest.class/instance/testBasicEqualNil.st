tests
testBasicEqualNil

	| reservations |
	reservations := session read: GlorpReservation where: [:each |
		each passenger isNIL].
	self assert: reservations size = 1.
	self assert: reservations first id = 7.