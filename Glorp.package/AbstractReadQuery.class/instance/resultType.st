accessing
resultType
	"Return the database type that we are expecting to return from this query. This only makes sense if we're returning a single field. If we return a collection of types, just return nil here. If we return a mapped object, the #type message will cause an exception."
	self tracing retrievalExpressions size = 1 ifFalse: [^nil].
	^self tracing retrievalExpressions asArray first type.