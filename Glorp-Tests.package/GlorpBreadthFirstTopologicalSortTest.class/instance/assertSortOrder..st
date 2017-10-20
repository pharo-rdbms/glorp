support
assertSortOrder: aCollection
	| ids |
	ids := (sorted collect: [:each | each id]) asArray.
	self assert: ids = aCollection asArray.