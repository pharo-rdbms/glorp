This is the central class used for writing. We build up a collection of rows that are to be written, indexed by the objects that "own" them. While any object can contribute values to a row (for example, in a relationship, the value of a field that is a foreign key may come from the primary key of another object) it is a central assumption that each row is owned by a single object. Once we know all the rows, we can compute which ones have changed from their previous database values (see RowMapForMementos) and which fields within them have changed, and then we can write them out.

Instance Variables:
	hasDeletions	<Boolean>	Do we have any deletions. Deletions are marked by a flag in the row, but it's useful to know quickly if we have any or not.
	rowDictionary	<(Dictionary from: DatabaseTable to: (Dictionary from: Object to: DatabaseRow)>	The rows, indexed by their table, then by the owning object.

