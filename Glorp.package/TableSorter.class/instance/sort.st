sorting
sort
	orderedTables := OrderedCollection new: tables size.
	tables do: [:each | self visit: each].
	^orderedTables select: [:each | tables includes: each]