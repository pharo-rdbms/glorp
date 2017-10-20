validation
initializeRuntimeMappings

	session isNil ifFalse: [session system == self ifFalse: [InvalidSessionSetup signal: 'Invalid session setup']].
	self allTables.
	self allDescriptors do: [:each | each initializeRuntimeMappings]