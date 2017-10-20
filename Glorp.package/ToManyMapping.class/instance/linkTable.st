private/expressions
linkTable
	| referenceKeys |
	self usesLinkTable ifFalse: [^nil].
	referenceKeys := (self join) targetKeys asOrderedCollection.
	^referenceKeys first table.