bound values
rowAtATimeBindings
	"Return multiple sets of bindings in a form suitable for iterating over"
	| allBindings fields rowTemplate |
	fields := self arrayBoundFields.
	rowTemplate := Array new: fields size.
	allBindings := Array new: allRows size.
	1 to: allBindings size do: [:i | | currentRow input |
		currentRow := rowTemplate copy.
		input := allRows at: i.
		allBindings at: i put: currentRow.
		1 to: fields size do: [:j |
			currentRow at: j put: (input at: (fields at: j) ifAbsent: [nil])]].
	^allBindings asArray.