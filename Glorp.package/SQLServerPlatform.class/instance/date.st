types
date
	"SQL Server does not compare a timestamp that's cast to a date as being equal to a date, which is the behaviour we expect. Its dates are really timestamps internally, so just treat date and timestamp as the same."
	^self timestamp.