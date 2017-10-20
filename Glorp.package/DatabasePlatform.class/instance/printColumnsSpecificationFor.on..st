services columns
printColumnsSpecificationFor: aGlorpDatabaseTable on: sqlStatementStream
	aGlorpDatabaseTable fields isEmpty not
		ifTrue:
			[| sepFlag |
			sqlStatementStream
				space;
				nextPut: $(.
			sepFlag := false.
			aGlorpDatabaseTable fields
				do:
					[:eachGlorpDatabaseField | 
					sepFlag
						ifTrue:
							[sqlStatementStream nextPutAll: self columnNameSeparatorString].
					self printColumn: eachGlorpDatabaseField on: sqlStatementStream.
					sepFlag := true]].