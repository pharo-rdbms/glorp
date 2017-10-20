printing
printLeftoverTablesOn: aCommand
	"Now there might be leftover tables whose joins were implied directly by the where clause"
	| leftOverTables |
	leftOverTables := self allTables asSet copy.
	availableTables do: [:each | leftOverTables remove: each ifAbsent: []].
	leftOverTables isEmpty ifFalse: [aCommand nextPutAll: ', '].
	GlorpHelper
		print: [:each | each sqlTableName]
		on: aCommand
		for: leftOverTables
		separatedBy: ', '