accessing
primaryKeyFields

	primaryKeyFields isNil ifTrue: [primaryKeyFields := fields select: [:each | each isPrimaryKey yourSelf "might be a proxy"]].
	^primaryKeyFields.