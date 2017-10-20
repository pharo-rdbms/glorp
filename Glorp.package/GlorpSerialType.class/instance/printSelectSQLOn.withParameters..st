testing
printSelectSQLOn: aCommand withParameters: aDictionary
	"We record our type as serial, but that isn't really useful for a cast. We assume serials are integers, so just print a generic integer type instead."
	self platform integer printSelectSQLOn: aCommand withParameters: aDictionary.