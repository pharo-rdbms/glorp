sorting
secondVisit
	sorted add: current.
	current status: #done.
	current parent isNil
		ifFalse:
			[((self childrenOf: current parent)
				allSatisfy: [:each | each status == #done])
				ifTrue: [queue add: current parent].
			current parent: nil].