private/restoring
restoreIndexedInstanceVariablesOf: original toThoseOf: copy

	copy glorpStartOfIndexedInstVars to: copy glorpEndOfIndexedInstVars do: [:index |
		original isString 
			ifTrue: [original at: index put: (copy at: index)]
			ifFalse: [original basicAt: index put: (copy basicAt: index)]]