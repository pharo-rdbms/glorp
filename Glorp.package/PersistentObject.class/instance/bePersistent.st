actions
bePersistent
	"Queue our object to be saved to the database upon commit."

	self session
		requireUnitOfWork;
		register: self