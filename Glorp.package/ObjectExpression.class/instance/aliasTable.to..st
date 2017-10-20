fields
aliasTable: aDatabaseTable to: aString 
	| newTable |
	newTable := aDatabaseTable copy.
	newTable name: aString.
	newTable parent: aDatabaseTable.
	newTable schema: ''.
	self tableAliases at: aDatabaseTable put: newTable