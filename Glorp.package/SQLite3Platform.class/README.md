I support Glorp's use of the SQLite database;  see http://www.sqlite.org.  Some notes on the implementation:

SQLite provides no specific support for time-related data other than column-default-value UTC functions:
	CURRENT_DATE format YYYY-MM-DD
	CURRENT_TIME format HH:MM:SS
	CURRENT_TIMESTAMP format YYYY-MM-DD HH:MM:SS
I therefore map Date, Time and Timestamp to and from strings via #to... and (inherited) #read... methods whose formats agree with these functions.  (I also return false to #supportsMillisecondsInTimes, again in agreement with the above functions which do not include millliseconds.)

My #maximumLengthOfTableName value is limited purely for convenience;  it can probably be much larger.

In VW, this version uses the non-threaded SQLite3Connection EXDI class.  Make my #vwEXDIConnectionClass return SQLite3ThreadedConnection to make Glorp use the threaded interface and, if using this with Store, also change its string reference in #asGlorpDatabase, #databaseFor:.  Alternatively, create an SQLlite3ThreadedPlatform subclass of me and add an extra line, instead of changing a line, to the Store methods.  (Note that in order to be thread-safe, your SQLite installation must be compiled with the SQLITE_THREADSAFE preprocessor macro set to 1.  In SQLite3, both the Windows and Linux precompiled binaries in the distribution are compiled this way.  If you are unsure if the SQLite library you are linking against is compiled to be threadsafe you can call the sqlite3_threadsafe()  interface to find out.)

SQLite parses FOREIGN KEY constraints but does not enforce them.

SQLite's approach to data typing is unusual for SQL.  Its data values are:
	NULL
	INTEGER. The value is a signed integer, stored in 1, 2, 3, 4, 6, or 8 bytes depending on the magnitude of the value.
	REAL. The value is a floating point value, stored as an 8-byte IEEE floating point number.
	TEXT. The value is a text string, stored using the database encoding (UTF-8, UTF-16BE or UTF-16-LE).
	BLOB. The value is a blob of data, stored exactly as it was input
but its typing is dynamic, so any column can in principle store any value, and its column affinities are
	TEXT - can store NULL, TEXT or BLOB
	NUMERIC - can store all five; text values that converts to reals or integers without loss of information are so stored
	INTEGER - as NUMERIC plus reals that convert to integer without loss of information are so stored
	REAL - as NUMERIC but integer values are coerced to reals
	NONE - no coercion is performed.
My int* and float*/double type methods that define Glorp types for SQLite conform to the expressibility of the above data values.

