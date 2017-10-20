This is the error we raise when we encounter an exception inside Glorp's database write code. This is uniform across dialects, so it can be reliably caught. We wrap the underlying exception.

Instance Variables:
	accessor	<DatabaseAccessor>	The accessor we were executing against.
	command	<DatabaseCommand>	The command we were executing
	databaseError	<Exception>	The exception that the system raised.

