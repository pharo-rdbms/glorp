api/queries
read: aClass orderBy: aCriteria
	"aCriteria can be a block, such as [:each | each id], or a symbol (that Glorp can translate into such a block), such as #id."

	| query |
	query := SimpleQuery read: aClass.
	query orderBy: aCriteria.
	^self execute: query