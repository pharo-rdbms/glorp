accessing
printSQL
	| iterations |
	iterations := self shouldUseGroupWriting
		ifTrue:
			[self platform usesArrayBindingRatherThanGroupWriting
				ifTrue: [1]
				ifFalse: [allRows size]]
		ifFalse: [1].
	GlorpHelper
		do:
			[:i | self basicPrintSQLFor: (i = 1 ifTrue: [row] ifFalse: [allRows at: i])]
		for: (1 to: iterations)
		separatedBy: [self nextPutAll: '; '].