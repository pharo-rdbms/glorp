accessing
shouldCreateInDatabase: aBoolean
	"If false, then this is a constraint that we use for in-memory ordering, but it should not be created in the database, possibly for performance, or because it might cause a cycle"
	shouldCreateInDatabase := aBoolean