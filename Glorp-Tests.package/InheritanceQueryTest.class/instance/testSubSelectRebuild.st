running
testSubSelectRebuild
	| query |
	query := Query read: Station where: 
		[:station |
		station successor anySatisfy:
			[:successor |
			successor successorCustomer id = 1 OR: [successor successorFeeder id = 1]]].
	"session accessor logOnlyOn: Transcript."
	session execute: query.
	"query := query asFullQuery.
	query session: session.
	query setUpExpressions.
	query asSimpleQueryFor: CustomerStation"