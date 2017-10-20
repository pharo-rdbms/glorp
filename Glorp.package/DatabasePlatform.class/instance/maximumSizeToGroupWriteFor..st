binding
maximumSizeToGroupWriteFor: aCollectionOfDatabaseRows
	"If we are going to group write, how many rows of this collection should we do it for at once"
	^aCollectionOfDatabaseRows size.