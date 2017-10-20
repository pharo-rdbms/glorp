converting
asFullQuery
	| newQuery |
	newQuery := ReadQuery new
		initResultClass: resultClass whereClause: whereClause singleObject: readsOneObject.
	self copyAttributesTo: newQuery.
	newQuery setOrdering: ordering.
	newQuery setGrouping: grouping.
	^newQuery.