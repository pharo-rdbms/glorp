sql generation
printGroupingOn: aStream
	grouping isNil
		ifTrue: [ ^ self ].
	aStream nextPutAll: ' GROUP BY '.

	GlorpHelper
		do: [:each |
			each
				rewriteFunctionArguments;
				printSQLOn: aStream withParameters: nil]
		for: grouping
		separatedBy: [aStream nextPutAll: ', ']