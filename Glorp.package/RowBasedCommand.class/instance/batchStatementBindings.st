bound values
batchStatementBindings
	"Return our bindings, which we assume are for multiple rows, as one big array, one statement after the other"

	| bound fields |
	fields := self arrayBoundFields.
	bound := OrderedCollection new: allRows size * fields size.
	allRows do: [:eachRow | 
		fields do: [:each | 
			| fieldValue |
			fieldValue := eachRow at: each ifAbsent: [nil].
			(self canBind: fieldValue to: each type) ifTrue: [bound add: fieldValue]]].
	^bound asArray.