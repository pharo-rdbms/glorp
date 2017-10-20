copying
withTable: aTable
	"Return a copy of ourselves, with the table set to aTable. Presumably aTable is an aliased version of our table"
	^self copy table: aTable.