*Glorp
find: primaryKey
	"Query the database for an object whose primary key = the given value."
	"Person find: 1"

	| session |
	session := self getSession.
	^session execute: (self query: primaryKey).