This is the error we raise if we encounter an error trying to write some rows. This typically indicates an optimistic lock failure, although it might also happen if we violated a constraint.

Instance Variables:
	command	<DatabaseCommand>	The command we were trying to execute.
	object	<Object>	The object or objects we were trying to write.

