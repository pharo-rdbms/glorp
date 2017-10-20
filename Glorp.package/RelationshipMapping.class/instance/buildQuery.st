mapping
buildQuery
	| toMany |
	toMany := self attribute isCollectionAttribute.
	query := toMany
		ifTrue: [Query read: self referenceClass where: self join]
		ifFalse: [Query readOneOf: self referenceClass where: self join].
	query session: self session.
	query baseExpression descriptor: (self session descriptorFor: self referenceClass).
	query collectionType: self collectionType.
	self usesLinkTable ifTrue: [
		query AND: (self expressionFromLinkToReferenceTableWithBase: query baseExpression)].
	^query.