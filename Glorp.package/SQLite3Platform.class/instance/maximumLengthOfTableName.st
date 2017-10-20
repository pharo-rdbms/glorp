constants
maximumLengthOfTableName
	"It is the boast of SQLite that their limits are only for stability purposes:  if it fits in 32 bits then they will handle it.  Since the maximum length of an SQL statement is limited to SQLITE_MAX_LENGTH (defaults to 1000000, cannot be higher than 1073741824), table names had better be shorter and in normal use should be much shorter.  I chose the number below at random;  change it if it causes you any inconvenience."

	^128