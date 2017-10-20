preparing
_rewriteFunctionArguments
	"SUBSTR wants arguments position and length rather than (start) position and end position in Postgres, Oracle (not OracleODBC), MySQL, SQL Server and DB2."

	Halt now.
	base ultimateBaseExpression system platform usesLengthNotEndPosInSubstring
		ifTrue: [arguments last value: arguments last value - arguments first value + 1].