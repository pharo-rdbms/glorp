conversion-boolean
printBoolean: aBoolean for: aType
	"If the platform is MS SQL Server, a boolean object in a SELECT needs to be converted to  BIT type, since T, Y, or true make SQLServer complain. "
	| stream |
	stream := WriteStream on: String new.
	aBoolean glorpPrintSQLOn: stream.
	^stream contents.