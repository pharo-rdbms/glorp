tests
testEqualToIdsInExpression
	"Just to verify that this works when not directly comparing objects"

	| reservations |
	reservations := session read: GlorpReservation where: [:each |
		each passengers anySatisfy: [:eachPassenger | eachPassenger id = each passenger id]].
	self assert: reservations size = 1.
	self assert: reservations first id = 2.
	self assert: reservations first passenger id = 3.