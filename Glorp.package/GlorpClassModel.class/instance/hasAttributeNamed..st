accessing
hasAttributeNamed: aSymbol

	attributes do: [:attribute | attribute name = aSymbol ifTrue: [^true]].
	^false