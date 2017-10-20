tests
testNotEqualToObjectInExpression
	"A somewhat contrived example of comparing two relationships that should end up with the same object, because they're actually mapped the same way. But will fail if the passenger is nil, because nil ~= nil"

	| reservations |
	reservations := session read: GlorpReservation where: [:each |
		each passengers anySatisfy: [:eachPassenger | eachPassenger ~= each passenger]].
	self assert: reservations isEmpty.