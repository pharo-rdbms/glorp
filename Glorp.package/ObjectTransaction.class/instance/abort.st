begin/commit/abort
abort
	undoMap keysAndValuesDo: [:original :copy | self restoreStateOf: original toThatOf: copy]