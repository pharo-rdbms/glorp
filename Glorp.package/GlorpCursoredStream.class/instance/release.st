initializing
release
	super release.
	self releaseCursor.
	cursor := nil.
	rawPeekBuffer := nil.
	peekBuffer := nil.
	statement isNil
		ifFalse:
			[databaseAccessor reusePreparedStatements
				ifTrue: [statement busy: false]
				ifFalse: [statement release].
			statement := nil].
	databaseAccessor := nil.