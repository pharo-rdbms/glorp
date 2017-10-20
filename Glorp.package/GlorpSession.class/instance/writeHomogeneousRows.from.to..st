read/write
writeHomogeneousRows: aCollectionOfDatabaseRows from: startIndex to: endIndex
	"Write out the specified range from a collection of rows belonging to a single table"

	| succeeded |
	succeeded := true.
	^(self system 	
			canUseGroupedWritesFor: (aCollectionOfDatabaseRows at: startIndex) table)
		ifTrue: [self groupWrite: (aCollectionOfDatabaseRows copyFrom: startIndex to: endIndex)]
		ifFalse:
			[startIndex to: endIndex do: [:i |
				 |eachRow rowSucceeded |
				eachRow := aCollectionOfDatabaseRows at: i.
				rowSucceeded := self writeRow: eachRow.
				succeeded := succeeded & rowSucceeded].
			succeeded].