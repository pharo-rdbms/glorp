A UnitOfWork keeps track of objects which might potentially be modified and lets you roll them back or commit the changes into the database.

Instance Variables:
	newObjects	<IdentitySet of: Object>	The objects registered with us as being new (i.e. not existing already in the database)
	session	<Session>	The session in which this is all taking place.
	transaction	<ObjectTransaction>	Keeps track of the original object state so that we can revert it.
	rowMap	<RowMap>	A holder for the rows when we are writing out changes.
	commitPlan	<(OrderedCollection of: DatabaseRow)>	The list of rows to be written, in order. Constructed by topological sorting the contents of the row map.
	calculatingRows <Boolean> Are we in the process of computing the rows to be written. If so, we should not be doing reads and registrations - it's probably an error in the mapping code by accidentally forcing a read.

