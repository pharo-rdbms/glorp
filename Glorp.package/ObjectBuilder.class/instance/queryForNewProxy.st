building objects
queryForNewProxy
	"Create a proxy with a primary key query in which the parameters are the primary key fields. We can't just reuse a mapping's query, it has to be a new primary key one, because the mapping's query has just run and been told to return proxies. This kind of stinks"
	| whereExpression |
	whereExpression := Join new.
	self descriptor primaryTable primaryKeyFields do: [:eachField | 
		whereExpression addSource: eachField target: eachField].
	^Query
		readOneOf: query resultClass 
		where: whereExpression