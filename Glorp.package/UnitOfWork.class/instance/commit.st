begin/commit/abort
commit
	[self preCommit.
	self writeRows] ifCurtailed: [succeeded := false].
	succeeded
		ifTrue: [self postCommit]
		ifFalse:
			[GlorpTransactionFailure signal]