settings
shouldForeignKeyValueBeTreatedAsNull: aValue
	"Return true if this foreign key value should be treated as null, meaning there's no relationship. Normally this means just nil, but descriptor systems can override if they have special values which they use (e.g. 0) that indicate a missing relationship. This can improve performance by avoiding unnecessary queries to the database for things we know will never return a result"
	^aValue isNil