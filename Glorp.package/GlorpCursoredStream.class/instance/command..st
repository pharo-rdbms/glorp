accessing
command: aDatabaseCommand
	command := aDatabaseCommand.
	aDatabaseCommand isNil ifTrue: [^self].
	aDatabaseCommand query isNil ifTrue: [^self].
	databaseAccessor := aDatabaseCommand query session accessor.
	builders := self query copyOfBuilders.
	builders do: [:each | each cursor: self]