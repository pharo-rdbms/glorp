printing
unqualifiedSqlTableName
	"Our name, as appropriate for the list of tables in a SQL statement. Take into account aliasing"

	^parent isNil
		ifTrue:
			[self isImaginary
				ifTrue: [self imaginaryReplacementName]
				ifFalse: [self qualifiedName]]
		ifFalse: [parent sqlTableName].