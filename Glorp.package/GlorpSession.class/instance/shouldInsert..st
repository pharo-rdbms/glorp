internal/writing
shouldInsert: aDatabaseRow

	"We may have forced this to explicitly be an update"
	| isMappedObjectRow |
	(currentUnitOfWork notNil and: [currentUnitOfWork forcesUpdateFor: aDatabaseRow]) ifTrue: [^false].

	"If this is for a mapped object, so not a link table, then we are an insert if there is no corresponding row in the cache that we read from the database, and an update if there is such a row." 
	isMappedObjectRow := (RowMap new isRowMapKey: aDatabaseRow owner) not.
	isMappedObjectRow ifTrue: [
		^(self cacheContainsObjectForRow: aDatabaseRow) not].

	"This is a link table row. If the relationship existed before registration, then this will have an old version and we should update it. If there's no old version, then it's an insert."

	^aDatabaseRow hasOldVersion not