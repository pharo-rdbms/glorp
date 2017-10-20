copying
withTable: aTable
	"Modify (do not copy) ourselves to use aTable. Presumably aTable is an aliased version of our table"
	field := field withTable: aTable.