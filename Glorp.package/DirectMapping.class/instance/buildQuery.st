mapping
buildQuery
	"We just want to read our main object back again. So we create a join from our primary key fields to themselves. One side will remain field references, the other side will turn into parameters when it's converted to a where clause."
	| whereClause |
	whereClause := Join new.
	descriptor primaryTable primaryKeyFields do: [:each |
		whereClause addSource: each target: each].
	query := Query readOneOf: descriptor describedClass where: whereClause.
	query retrieve: self attribute name.
	query session: self session.
	^query.