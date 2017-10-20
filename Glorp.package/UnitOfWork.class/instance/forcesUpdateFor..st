testing
forcesUpdateFor: aDatabaseRow
	^linkRowsForUpdate notNil and: [linkRowsForUpdate includes: aDatabaseRow]