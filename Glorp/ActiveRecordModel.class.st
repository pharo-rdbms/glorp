"
I am a base class for ActiveRecord objects.

It is not essential to use me but I provide a number of convenient class side query helpers.

New projects should subclass me and use that subclass as the base class for the project.

The project base class should have a class method 'session' to share a session among instances in the current context.  In seaside this might be tied to the current web session.
"
Class {
	#name : #ActiveRecordModel,
	#superclass : #Object,
	#category : #'Glorp-ActiveRecord'
}

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> all [ 
	^self query execute
]

{ #category : #setup }
ActiveRecordModel class >> descriptorClass [
	"You should return a subclass of ActiveRecordDescriptorSystem here "
	self subclassResponsibility 

]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> find [
	^self query
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> find: aPrimaryKey [
	| pkAttribute cachedSession |
	cachedSession := self session.
	pkAttribute := (cachedSession system descriptorFor: self) primaryKeyMappings first attribute name.
	^(cachedSession queryClass readOneOf: self where: [:each | (each perform: pkAttribute) = aPrimaryKey]) execute.
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> findAll [
	^self query
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> first [ 
	^((self instVarIndexFor: #createdAt ifAbsent: [  ] ) 
		ifNil: [ (self oneWhere: nil) orderBy: [:ea | ea id  ] ]
		ifNotNil: [ (self oneWhere: nil) orderBy: [:ea | ea createdAt ] ]) execute
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> first: aNumber [
	^(self query orderBy: [:ea | ea id ]) first: aNumber
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> last [ 
	^((self instVarIndexFor: #createdAt ifAbsent: [  ] ) 
		ifNil: [ (self oneWhere: nil) orderBy: [:ea | ea id descending] ]
		ifNotNil: [ (self oneWhere: nil) orderBy: [:ea | ea createdAt descending] ]) execute

]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> last: aNumber [
	^(self query orderBy: [ :ea | ea id descending ]) limit: aNumber 
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> limit: aNumber [ 
	^self query limit: aNumber 
]

{ #category : #accessing }
ActiveRecordModel class >> newSession [
	^self descriptorClass newSession
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> oneWhere: aBlock [ 
	^self session queryClass readOneOf: self where: aBlock 
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> orderBy: aBlock [
	^self query orderBy: aBlock
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> query [
	"Handle soft deletes"
	^(self instVarNames includes: #deletedAt  ) 
		ifTrue: [ self session queryClass read: self where: [:ea | ea deletedAt isNil ] ]
		ifFalse: [ self session queryClass read: self ]
]

{ #category : #accessing }
ActiveRecordModel class >> session [ 
	"Delegated down because a base class should have a class variable called session shared among subclasses.  This allows clusters of objects to have different sessions based on base class."
	self subclassResponsibility 
]

{ #category : #accessing }
ActiveRecordModel class >> table [ 
	^(self session system descriptorFor: self) table
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> where: aBlock [
	^ActiveRecordQuery read: self where: aBlock
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> where: aBlock limit: aLimit [
	^ActiveRecordQuery read: self where: aBlock limit: aLimit
]

{ #category : #actions }
ActiveRecordModel >> save [ 
	self session
		requireUnitOfWork;
		register: self.
		
	self session commitUnitOfWorkAndContinue.
	
	^self
]

{ #category : #actions }
ActiveRecordModel >> session [ 
	^self class session
]
