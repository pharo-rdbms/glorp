mapping
buildQuery
	| toMany |
	toMany := self attribute isCollectionAttribute.
	query := toMany
		ifTrue: [SQLite3PragmaQuery read: self referenceClass where: self join]
		ifFalse: [SQLite3PragmaQuery readOneOf: self referenceClass where: self join].
	query session: self session.
	query baseExpression descriptor: (self session descriptorFor: self referenceClass).
	query collectionType: self collectionType.
	self usesLinkTable ifTrue: [
		query AND: (self expressionFromLinkToReferenceTableWithBase: query baseExpression)].
	orderBy isNil ifFalse: [orderBy do: [:each | query orderBy: each]].
	^query