mapping
buildGeneralQueryIn: anObjectBuilder
	| newQuery |
	newQuery := super buildGeneralQueryIn: anObjectBuilder.
	orderBy isNil ifFalse: [orderBy do: [:each | newQuery orderBy: each]].
	^newQuery