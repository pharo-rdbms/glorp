"
This is an abstract superclass for Glorp persistent objects. Things don't have to subclass from this in order to be persistent, but if they do, they will inherit some methods which may be useful.
"
Class {
	#name : #PersistentObject,
	#superclass : #Object,
	#instVars : [
		'session'
	],
	#category : #'Glorp-Core'
}

{ #category : #'class factory' }
PersistentObject class >> classModel [
	^self descriptor classModel
]

{ #category : #accessing }
PersistentObject class >> count [
	"Count the number of objects in the database"
	"Person count"

	^ self getSession count: self
]

{ #category : #accessing }
PersistentObject class >> descriptor [
	^self getSession descriptorFor: self
]

{ #category : #reading }
PersistentObject class >> find: primaryKey [
	"Query the database for an object whose primary key = the given value."
	"Person find: 1"

	| session |
	session := self getSession.
	^session execute: (self query: primaryKey).
]

{ #category : #reading }
PersistentObject class >> findAll [
	"Query the database for all objects of this class."
	"Person findAll"
	^self getSession read: self.
]

{ #category : #reading }
PersistentObject class >> findWhere: aBlock [
	"Query the database for all objects of this class satisfying aBlock. The block has to be a query block, meaning you can't execute arbitrary code, but rather it will be analyzed and used to generate SQL."
	"Person findWhere: [:each | (each name = 'John Doe') & (each address houseNum = 1000)]"

	^self getSession read: self where: aBlock.
]

{ #category : #'error signalling' }
PersistentObject class >> getSession [
	"Return the session to be used for the current query. In general, we don't know how to find our session. Callers can catch the CannotFindSession exception and resume it, or subclasses can implement this method to find the session using mechanisms like process environment, a global, or whatever else they have available."
	^CannotFindSession raise.
]

{ #category : #reading }
PersistentObject class >> query: primaryKey [
	"Return a query object that will query the database for an object whose primary key = the given value. If you want to just return the object, use find: instead. The advantage of this is that you can use this to get a basic query, but then modify it before executing it."
	"Person query: 1"

	| pkAttribute session |
	session := self getSession.
	pkAttribute := (session system descriptorFor: self) primaryKeyMappings first attribute name.
	^Query readOneOf: self where: [:each | (each perform: pkAttribute) = primaryKey].
]

{ #category : #reading }
PersistentObject class >> queryAll [
	"Return a query object that will query the database for all objects of this class. If you want to just return the object, use find: instead. The advantage of this is that you can use this to get a basic query, but then modify it before executing it."
	"Person queryAll"
	^Query read: self.
]

{ #category : #reading }
PersistentObject class >> queryWhere: aBlock [
	"Return a Query object that will query the database for all objects of this class satisfying aBlock. The block has to be a query block, meaning you can't execute arbitrary code, but rather it will be analyzed and used to generate SQL. If you want to just return the objects, use findWhere: instead. The advantage of this is that you can use this to get a basic query, but then modify it before executing it, e.g. using AND: or OR:."
	"Person queryWhere: [:each | (each name = 'John Doe') & (each address houseNum = 1000)]"

	^Query read: self where: aBlock.
]

{ #category : #accessing }
PersistentObject class >> table [
	^self descriptor ifNotNil: [:descriptor | descriptor table]
]

{ #category : #comparing }
PersistentObject >> = anObject [
	"Implement equality to compare primary keys if they are set. Make sure that if we have proxies, we check through them."

	| descriptor myKey |
	self class = anObject yourSelf class ifFalse: [^false].
	descriptor := self descriptor.

	"If the primary keys aren't equal, then we know for sure we are unequal. Otherwise we have to check further."
	myKey := descriptor primaryKeyCollectionFor: self.
	myKey = (descriptor primaryKeyCollectionFor: anObject)
		ifFalse: [^false].

	"If the primary key contains nils, then fall back to the default equality comparison. If they don't, and are equal, then the objects are equal."
	^(myKey includes: nil)
		ifTrue: [super = anObject yourSelf]
		ifFalse: [true]
]

{ #category : #actions }
PersistentObject >> bePersistent [
	"Queue our object to be saved to the database upon commit."

	self session
		requireUnitOfWork;
		register: self
]

{ #category : #accessing }
PersistentObject >> classModel [

	^ self descriptor classModel
]

{ #category : #actions }
PersistentObject >> commitUnitOfWork [
	"Commit the entire unit of work; this may include objects other than myself."

	self session hasUnitOfWork ifFalse: [^self].
	self session commitUnitOfWork
]

{ #category : #actions }
PersistentObject >> delete [
	"Queue our object to be removed from the database on commit."

	self session delete: self
]

{ #category : #accessing }
PersistentObject >> descriptor [

	^ self session descriptorFor: self class
]

{ #category : #'finding objects' }
PersistentObject >> find [
	"This is a query by example facility. We take whichever fields are filled in the object and read back any objects in the database that match."

	| instances |
	instances := GlorpVirtualCollection on: self class in: self session.
	self descriptor mappings do: [ :eachMapping |
		instances := self findMapping: eachMapping in: instances ].
	^ instances
]

{ #category : #private }
PersistentObject >> findMapping: aMapping in: aVirtualCollection [

	aMapping hasAttribute ifFalse: [ ^ aVirtualCollection ].
	aMapping attribute name = #session ifTrue: [ ^ aVirtualCollection ].
	^ (aMapping attribute getValueFrom: self)
		  ifNil: [ aVirtualCollection ]
		  ifNotNil: [ :value |
			  aVirtualCollection select: [ :each |
				  self
					  matchAttribute: (each get: aMapping attribute name)
					  to: value ] ]
]

{ #category : #comparing }
PersistentObject >> hash [
	"Implement hash to compare primary keys if they are set. Make sure that if we have proxies, we check through them."

	| myKey |
	"If the primary key contains nils, then fall back to the default hash. If they don't, hash the collection."
	myKey := self descriptor primaryKeyCollectionFor: self.
	^ (myKey includes: nil)
		  ifTrue: [ super hash ]
		  ifFalse: [ myKey hash ]
]

{ #category : #private }
PersistentObject >> matchAttribute: anExpression to: value [
	"We match expressions differently depending on what type they are."

	^ (value isString and: [ value includes: $% ])
		  ifTrue: [ anExpression like: value ]
		  ifFalse: [ anExpression = value ]
]

{ #category : #actions }
PersistentObject >> refresh [
	"Refresh our object from the database and rollback any changes registered in the unit of work."

	self rollback.
	self session refresh: self
]

{ #category : #actions }
PersistentObject >> rollback [
	"Rollback our entries in the queue so that we are not involved in the commit."

	self session hasUnitOfWork ifFalse: [ ^ self ].
	self session rollbackUnitOfWorkFor: self
]

{ #category : #actions }
PersistentObject >> rollbackUnitOfWork [
	"Rollback the entire unit of work; this may include objects other than myself."

	self session hasUnitOfWork ifFalse: [ ^ self ].
	self session rollbackUnitOfWork
]

{ #category : #accessing }
PersistentObject >> session [

	session ifNil: [ session := self class getSession ].
	^ session
]

{ #category : #accessing }
PersistentObject >> session: aGlorpSession [

	session := aGlorpSession
]
