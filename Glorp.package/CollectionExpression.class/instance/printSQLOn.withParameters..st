printing SQL
printSQLOn: aStream withParameters: aDictionary 
	"Don't print the left child or ourselves, just the expression that is the right side.
e.g. aPerson addresses anySatisfy: [:each | each city='Ottawa'] prints as
where (address.city = 'Ottawa')
The relation 'aPerson addresses' will ensure that the join gets printed"
	rightChild printSQLOn: aStream withParameters: aDictionary.