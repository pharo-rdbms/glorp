read/write
writeHomogeneousRows: aCollectionOfDatabaseRows
	"Write out a collection of rows belonging to a single table"

	| representativeRow succeeded maximumSize start |

	aCollectionOfDatabaseRows isEmpty ifTrue: [^true].
	representativeRow := aCollectionOfDatabaseRows first.
	representativeRow shouldBeWritten ifFalse: [^true].
	succeeded := true.
	maximumSize := self system maximumSizeToGroupWriteFor: aCollectionOfDatabaseRows.
	start := 1.
	[start > aCollectionOfDatabaseRows size] whileFalse: [
		| end |
		end := (start + maximumSize - 1) min: aCollectionOfDatabaseRows size.
		succeeded := succeeded
			& (self writeHomogeneousRows: aCollectionOfDatabaseRows from: start to: end).
		start := end + 1].
	^succeeded.