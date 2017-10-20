This represents a function which prints prefix, printing CASE, followed by the argument in parentheses, and then the rest of the MS SQL Server CASE statement, with a single test condition (WHEN) and a default value (ELSE):

CASE (arg1)
	WHEN arg2 THEN arg3 
	ELSE arg4
END AS arg5

For example:

CASE ('SELECT count(*) FROM aTable')
	WHEN '0' THEN 0 
	ELSE 1 
END AS arg3
