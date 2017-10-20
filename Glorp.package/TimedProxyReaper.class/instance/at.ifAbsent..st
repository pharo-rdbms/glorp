caching
at: id ifAbsent: errorBlock
	| result |
	[mutex wait.
	result := weakValueDictionary at: id ifAbsent: [^errorBlock value]]
		ensure: [mutex signal].
	^result.