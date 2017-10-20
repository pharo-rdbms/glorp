As yet unclassified
printForANSIJoinTo: table on: aCommand
	"Print ourselves as table JOIN otherTable USING (criteria). Return the table we joined"

	self outerJoin
		ifTrue: [aCommand nextPutAll: ' LEFT OUTER JOIN ']
		ifFalse: [aCommand nextPutAll: ' INNER JOIN '].
	aCommand nextPutAll: table sqlTableName.
	aCommand nextPutAll: ' ON '.
	self printSQLOn: aCommand withParameters: aCommand parameters.
	^table.