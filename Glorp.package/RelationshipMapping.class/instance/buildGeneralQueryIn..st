mapping
buildGeneralQueryIn: anObjectBuilder
	"For filtered queries. We need to build this in terms of the parent query"

	| base parentCriteria fullCriteria phantomExpression newQuery |
	base := BaseExpression new.
	base descriptor: self referenceDescriptor.
	phantomExpression := self addPhantomMappingExpressionOn: base.
	parentCriteria := anObjectBuilder query whereClause.
	fullCriteria := parentCriteria
		rebuildOn: phantomExpression.
	newQuery := Query read: self referenceClass.
	"newQuery collectionType: self collectionType."
	fullCriteria isEmptyExpression ifFalse: [newQuery where: fullCriteria].
	self
		setGeneralQueryRetrievalIn: newQuery
		basedOn: base
		phantom: phantomExpression.
	^newQuery.