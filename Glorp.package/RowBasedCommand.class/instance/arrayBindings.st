bound values
arrayBindings
	"Return bindings in a form suitable for Oracle array binding, i.e. a list of arguments, but each argument is itself a list of multiple values"
	| allBindings fields |
	fields := self arrayBoundFields.
	allBindings := (1 to: fields size)
		collect: [:each | Array new: allRows size].
	1
		to: allRows size
		do:
			[:rowNumber | 
			| inputRow |
			inputRow := allRows at: rowNumber.
			1
				to: fields size
				do:
					[:columnNumber | 
					(allBindings at: columnNumber)
						at: rowNumber
						put: (inputRow at: (fields at: columnNumber) ifAbsent: [nil])]].
	^allBindings asArray.