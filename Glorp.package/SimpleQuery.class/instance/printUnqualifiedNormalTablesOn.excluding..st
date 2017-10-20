sql generation
printUnqualifiedNormalTablesOn: aCommand excluding: aCollection
	aCollection do: [:each | self tablesToPrint remove: each].
	GlorpHelper
		print: [:table | table unqualifiedSqlTableName]
		on: aCommand
		for: self tablesToPrint
		separatedBy: ', '.
	^self tablesToPrint.