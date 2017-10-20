set operations
differenceFrom: aMementoRowMap
	| differencesMap |
	differencesMap := RowMap new.
	self	additiveDifferencesFrom: aMementoRowMap into: differencesMap.
	self	subtractiveDifferencesFrom: aMementoRowMap into: differencesMap.
	^differencesMap