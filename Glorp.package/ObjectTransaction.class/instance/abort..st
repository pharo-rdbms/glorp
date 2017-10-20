begin/commit/abort
abort: original
	| copy |
	copy := undoMap at: original ifAbsent: [^self].
	self restoreStateOf: original toThatOf: copy