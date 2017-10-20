internal/writing
commandForHomogeneousRows: aCollectionOfDatabaseRows
	"Create the command for this set of rows. These are assumed to be homogeneous, in that they are all for the same table, and are all the same type of operation (i.e. all insert or all update)"
	| representativeRow |
	representativeRow := aCollectionOfDatabaseRows first.
	representativeRow forDeletion ifTrue: [self error: 'invalid way of handling deletes (this should never happen)'].
	^(self shouldInsert: representativeRow)
		ifTrue: [InsertCommand forRows: aCollectionOfDatabaseRows useBinding: self useBinding session: self]
		ifFalse: [UpdateCommand forRows: aCollectionOfDatabaseRows useBinding: self useBinding session: self]