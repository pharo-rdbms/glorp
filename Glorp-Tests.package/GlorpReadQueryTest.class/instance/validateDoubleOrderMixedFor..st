support
validateDoubleOrderMixedFor: query 
	| result sortedResult |
	result := session execute: query.
	sortedResult := result asSortedCollection: 
					[:a :b | 
					a street = b street 
						ifTrue: [a number <= b number]
						ifFalse: [a street > b street]].
	^self assert: sortedResult asArray = result asArray