accessing
parameterTypeSignature
	"Return a string indicating the parameter types. Complicated by the possibility of multiple rows, and of null values"
	| result |
	result := WriteStream on: String new.
	self hasMultipleRows
		ifTrue:
			[row
				keysAndValuesDo:
					[:eachKey :eachValInFirstRow| 
					| nextValue |
					eachValInFirstRow notNil
						ifTrue: [result nextPutAll: eachValInFirstRow class name]
						ifFalse:
							[allRows
								do:
									[:eachRow | 
									(nextValue := eachRow at: eachKey ifAbsent: [nil]) notNil
										ifTrue: [result nextPutAll: nextValue class name]]]]]
		ifFalse:
			[row
				keysAndValuesDo:
					[:eachKey :eachValue | result nextPutAll: eachValue class name]].
	^result contents.