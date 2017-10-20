support
tearDown
	oldReuseState isNil ifFalse:
		[session reusePreparedStatements: oldReuseState].
	session rollbackTransaction.
	session reset.
	session := nil.