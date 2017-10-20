accessing
addEmptyTableNamed: aString 
	| table |
	table := self databaseTableClass named: aString.
	self privateTableAt: aString put: table.
	^table