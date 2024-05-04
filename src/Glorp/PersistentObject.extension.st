Extension { #name : 'PersistentObject' }

{ #category : '*Glorp' }
PersistentObject class >> classModel [
	^self descriptor classModel
]

{ #category : '*Glorp' }
PersistentObject class >> count [
	"Count the number of objects in the database"
	"Person count"

	^ self getSession count: self
]

{ #category : '*Glorp' }
PersistentObject class >> descriptor [
	^self getSession descriptorFor: self
]

{ #category : '*Glorp' }
PersistentObject class >> find: primaryKey [
	"Query the database for an object whose primary key = the given value."
	"Person find: 1"

	| session |
	session := self getSession.
	^session execute: (self query: primaryKey).
]

{ #category : '*Glorp' }
PersistentObject class >> findAll [
	"Query the database for all objects of this class."
	"Person findAll"
	^self getSession read: self.
]

{ #category : '*Glorp' }
PersistentObject class >> findWhere: aBlock [
	"Query the database for all objects of this class satisfying aBlock. The block has to be a query block, meaning you can't execute arbitrary code, but rather it will be analyzed and used to generate SQL."
	"Person findWhere: [:each | (each name = 'John Doe') & (each address houseNum = 1000)]"

	^self getSession read: self where: aBlock.
]

{ #category : '*Glorp' }
PersistentObject class >> getSession [
	"Return the session to be used for the current query. In general, we don't know how to find our session. Callers can catch the CannotFindSession exception and resume it, or subclasses can implement this method to find the session using mechanisms like process environment, a global, or whatever else they have available."
	^CannotFindSession raise.
]

{ #category : '*Glorp' }
PersistentObject class >> query: primaryKey [
	"Return a query object that will query the database for an object whose primary key = the given value. If you want to just return the object, use find: instead. The advantage of this is that you can use this to get a basic query, but then modify it before executing it."
	"Person query: 1"

	| pkAttribute session |
	session := self getSession.
	pkAttribute := (session system descriptorFor: self) primaryKeyMappings first attribute name.
	^Query readOneOf: self where: [:each | (each perform: pkAttribute) = primaryKey].
]

{ #category : '*Glorp' }
PersistentObject class >> queryAll [
	"Return a query object that will query the database for all objects of this class. If you want to just return the object, use find: instead. The advantage of this is that you can use this to get a basic query, but then modify it before executing it."
	"Person queryAll"
	^Query read: self.
]

{ #category : '*Glorp' }
PersistentObject class >> queryWhere: aBlock [
	"Return a Query object that will query the database for all objects of this class satisfying aBlock. The block has to be a query block, meaning you can't execute arbitrary code, but rather it will be analyzed and used to generate SQL. If you want to just return the objects, use findWhere: instead. The advantage of this is that you can use this to get a basic query, but then modify it before executing it, e.g. using AND: or OR:."
	"Person queryWhere: [:each | (each name = 'John Doe') & (each address houseNum = 1000)]"

	^Query read: self where: aBlock.
]

{ #category : '*Glorp' }
PersistentObject class >> table [
	^self descriptor ifNotNil: [:descriptor | descriptor table]
]
