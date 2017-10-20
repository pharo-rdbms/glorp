actions
refresh
	"Refresh our object from the database and rollback any changes registered in the unit of work."

	self rollback.
	self session refresh: self