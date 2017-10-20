tests
testRegistration
	| person |
	session beginUnitOfWork.
	person := stream next.
	self assert: (session isRegistered: person).