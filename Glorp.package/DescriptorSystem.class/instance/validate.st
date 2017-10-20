validation
validate
	session isNil ifFalse: [session system == self ifFalse: [InvalidSessionSetup signal: 'Invalid session setup']].
	self allTables do: [:each | each validateIn: self].
	self allClassModels do: [:each | each validateIn: self].
	self allDescriptors do: [:each | each validate].