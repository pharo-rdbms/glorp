executing
executeSQLStringNoResult: aString
	^self
		executeSQLStringNoResult: aString
		doing: []
		forCommand: nil.