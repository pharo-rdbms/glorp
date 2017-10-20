*Glorp
query: primaryKey
	"Return a query object that will query the database for an object whose primary key = the given value. If you want to just return the object, use find: instead. The advantage of this is that you can use this to get a basic query, but then modify it before executing it."
	"Person query: 1"

	| pkAttribute session |
	session := self getSession.
	pkAttribute := (session system descriptorFor: self) primaryKeyMappings first attribute name.
	^Query readOneOf: self where: [:each | (each perform: pkAttribute) = primaryKey].