configuring
bePrimaryKey
	isPrimaryKey := true.
	isNullable := false.
	self table isNil ifFalse: [self table addAsPrimaryKeyField: self]