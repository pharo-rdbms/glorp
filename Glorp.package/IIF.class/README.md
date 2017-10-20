This represents a MS ACCESS function which prints prefix, printing IIF, followed by the argument in parentheses, and then the rest of the MS SQL Server CASE statement, with a single test condition (WHEN) and a default value (ELSE):

Example: IIF(Condition, ReturnIfTrue, ReturnIfValue)
	IIF ( base? = arg1, arg2, arg3 ) AS alias

For example:
	IIF (('SELECT count(*) FROM aTable')= '0', 0, 1 ) AS alias