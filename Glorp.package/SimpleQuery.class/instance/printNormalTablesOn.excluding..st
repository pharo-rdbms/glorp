sql generation
printNormalTablesOn: aCommand excluding: aCollection
	aCollection do: [:each | self tablesToPrint remove: each].
	GlorpHelper
		print: [:table | table sqlTableName]
		on: aCommand
		for: self tablesToPrint
		separatedBy: ', '.
	^self tablesToPrint