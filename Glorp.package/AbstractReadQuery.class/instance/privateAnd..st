private
privateAnd: anExpression
	"AND these two together without checking for common bases, rebuilding, etc. Everything had better be right"
	whereClause := whereClause AND: anExpression