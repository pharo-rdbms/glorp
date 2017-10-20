testing
isStoredInSameTable
	"Normally, a relationship mapping isn't stored in the same table, but if we're part of a dictionary mapping and the table is mapped to an association, then we want to be treated that way. The test is a horrible hack"
	^self classModel describedClass == Association.