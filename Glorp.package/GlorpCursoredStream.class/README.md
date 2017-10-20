This is a Glorp wrapper for a database cursor. It has stream-like behaviour, which is implemented by getting rows from the underlying cursor and constructing the objects as required. All queries go through one of these streams, although in the default case they will get all the results out of it (at which point the cursor will be closed) and then return them in another kind of collection. But it's possible to use one of these as the return type, in which case you can make use of the open cursor to incrementally get results.

Instance Variables:
	builders	<(Collection of: ObjectBuilder)>	The ObjectBuilders used to construct the objects we return out of the rows.
	buildersThatReturnResults	<(SequenceableCollection of: ElementBuilder)>	
	command	<DatabaseCommand>	The command that was executed to give us this cursor.
	cursor	<>	The underlying database cursor. Class varies by dialect. We deal with the lack of polymorphism by indirecting all cursor operations through the accessor.
	databaseAccessor	<DatabaseAccessor>	The accessor that the command was executed against.
	mightHaveDuplicateRows	<Boolean>	May this stream have duplicate rows? This can happen, for example, if we do a join that causes some sub-section of the row to be duplicated. If so, we need to check for this and remove duplicates from the object stream as we go. This forces us to peek ahead.
	peekBuffer	<Object>	The peek buffer (holding an object) that we use when peeking ahead.
	rawPeekBuffer	<>	The peek buffer (holding a row) that we use when peeking ahead. We need to buffer at both levels.
	statement	<GlorpPreparedStatement>	The actual prepared statement that the command ran in order to get our results.

