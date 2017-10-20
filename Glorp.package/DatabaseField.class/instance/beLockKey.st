configuring
beLockKey

	isLockKey := true.
	self table isNil ifFalse: [self table addAsLockKeyField: self]