initialize-release
initialize
	tables := OrderedCollection new: 100.
	visitedTables := IdentitySet new: 100