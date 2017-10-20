private/restoring
restoreNamedInstanceVariablesOf: original toThoseOf: copy

	1 to: copy class instSize do: [:index |
		original instVarAt: index put: (copy instVarAt: index)]