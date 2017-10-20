executing
filterResultsForParameters: parameterArray
	| passing seen |
	seen := Dialect newIdentitySet.
	passing := collection
		select:
			[:each | 
			| passes new value |
			passes := filter value: each value: parameterArray.
			value := self valueFor: each.
			passes
				ifTrue:
					[new := (seen includes: value) not.
					new ifTrue: [seen add: value]].
			passes and: [new]].
	^passing